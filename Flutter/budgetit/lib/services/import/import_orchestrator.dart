import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:decimal.dart';
import '../../databse/app_database.dart';
import '../../database/daos/transaction_dao.dart';
import '../../database/daos/category_dao.dart';
import '../../models/import/parsed_transaction.dart';
import '../../models/import/import_result.dart';
import '../../schema.dart';
import 'statement_parser_service.dart';
import 'classification_service.dart';
import 'duplicate_detector.dart';


class ImportOrchestrator {
    final AppDatabase _db;
    final TransactionDao _taDao;
    final CategoryDao _categoryDao;
    final StatementParserService _parser;

    ImportOrchestrator ({
        required AppDatabase db,
        required TransactionDao taDao,
        required CategoryDao categoryDao,
    })  
    :   _db = db,
        _taDao = taDao,
        _categoryDao = categoryDao,
        _parser = StatementParserService();


    Future<List<ParsedTransaction>> preparePreview(String filePath) async {
    final parsed = await _parser.parse(filePath);
    if (parsed.isEmpty) return [];


    final categories = await _categoryDao.getAllCategories();
    final nameToId = <String, String> {
        for (final c in categories) c.name: c.id,
    };

    final classifier = ClassificationService(nameToId);
    classifier.classifyAll(parsed);
    final existing = await _buildExistingSet();
    final detector = DuplicateDetector(existing);
    detector.flagDuplicates(parsed);
    return parsed;

}


Future<ImportResult> commitImport(
    List<ParsedTransaction> transactions, {
        bool forceAll = false,
    }) async {
        int inserted = 0;
        int duplicatesSkipped = 0;
        int failed = 0;
        final errors = <String, String> {};

        for (final ta in transactions) {
            if (ta.isDuplicate && !forceAll){
                duplicatesSkipped++;
                continue;
            }

            try {
                final dbta = await _taDao.insertTransaction(
                    amount: ta.amount,
                    type: ta.isTncome ? TransactionType.income : TransactionType.expense,

                    shortDescription: ta.shortDescription,
                    longDescription: ta.longDescription,
                    transactionDate: ta.date,
                    source: TransactionSource.import,
                );

                if (ta.categoryId != null) {
                    await _taDao.assignCategory(
                        transactionId: dbta.id,
                        categoryId: ta.categoryId!,
                        assignmentSource: ta.categoryOverridden
                        ? AssignemntSource.manual: AssignmentSource.ai,
                    );
                }

                inserted++;
            } 
            catch (e) {
                failed++;
                errors[ta.shortDescription] = e.toString();
            }
        }

        return ImportResult(
            totalParsed: transactions.length,
            inserted: inserted,
            duplicatesSkipped: duplicatesSkipped,
            failed: failed,
            errors: errors,
        );
    }


    Future<List<ExistingTransaction>> _buildExistingSet() async {
        final all = await _taDao.getAllTransactions();
        return all.map((t) {
            final key = '${t.transactionDate.toIso8601String()} | ${t.amount} | ${t.shortDescription.toLowerCase().trim()}';
            final hash = sha256.convert(utf8.encode(key)).toString().substring(0,16);

            return ExistingTransaction(
                date: t.transactionDate,
                amount: t.amount,
                deduplicationHash: hash,
            );
        }).toList();
    }
}
