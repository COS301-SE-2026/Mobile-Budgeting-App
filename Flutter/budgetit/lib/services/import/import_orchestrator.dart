import 'dart:convert';

import 'package:budgetit/database/schema.dart';
import 'package:crypto/crypto.dart';

import '../../database/app_database.dart';
import '../../database/daos/category_dao.dart';
import '../../database/daos/transaction_dao.dart';
import '../../models/import/import_result.dart';
import '../../models/import/parsed_transaction.dart';
import '../ai/transaction_classifier/transaction_classification_service.dart';
import 'classification_service.dart';
import 'duplicate_detector.dart';
import 'statement_parser_service.dart';

class ImportOrchestrator {
  final TransactionDao _taDao;
  final CategoryDao _categoryDao;
  final StatementParserService _parser;
  final TransactionClassificationService? _aiClassifier;

  ImportOrchestrator({
    required AppDatabase db,
    required TransactionDao taDao,
    required CategoryDao categoryDao,
    TransactionClassificationService? aiClassifier,
  }) : _taDao = taDao,
       _categoryDao = categoryDao,
       _aiClassifier = aiClassifier,
       _parser = StatementParserService();

  Future<List<ParsedTransaction>> preparePreview(String filePath) async {
    final parsed = await _parser.parse(filePath);

    if (parsed.isEmpty) {
      return [];
    }

    final categories = await _categoryDao.getAllCategories();

    final nameToId = <String, String>{
      for (final category in categories) category.name: category.id,
    };

    final keywordClassifier = ClassificationService(nameToId);
    keywordClassifier.classifyAll(parsed);

    if (_aiClassifier != null) {
      await _classifyUnmatchedExpensesWithAi(
        transactions: parsed,
        categories: categories,
      );
    }

    final existing = await _buildExistingSet();
    final detector = DuplicateDetector(existing);
    detector.flagDuplicates(parsed);

    return parsed;
  }

  Future<void> _classifyUnmatchedExpensesWithAi({
    required List<ParsedTransaction> transactions,
    required List<Category> categories,
  }) async {
    if (categories.isEmpty) {
      return;
    }

    final classificationCategories = [
      for (final category in categories)
        ClassificationCategory(id: category.id, name: category.name),
    ];

    for (final transaction in transactions) {
      if (transaction.categoryOverridden ||
          transaction.categoryId != null ||
          transaction.isIncome) {
        continue;
      }

      final result = await _aiClassifier!.classify(
        transactionId: _previewSourceId(transaction),
        shortDescription: transaction.shortDescription,
        longDescription: transaction.longDescription,
        categories: classificationCategories,
      );

      final bestMatch = result.bestMatch;

      if (bestMatch == null) {
        continue;
      }

      transaction.categoryId = bestMatch.categoryId;
      transaction.categoryName = bestMatch.categoryName;
    }
  }

  String _previewSourceId(ParsedTransaction transaction) {
    final existingHash = transaction.deduplicationHash.trim();

    if (existingHash.isNotEmpty) {
      return 'import-preview:$existingHash';
    }

    final sourceText = [
      transaction.date.toUtc().toIso8601String(),
      transaction.amount.toString(),
      transaction.description.trim().toLowerCase(),
    ].join('|');

    return 'import-preview:${sha256.convert(utf8.encode(sourceText))}';
  }

  Future<List<Category>> getAvailableCategories() {
    return _categoryDao.getAllCategories();
  }

  Future<ImportResult> commitImport(
    List<ParsedTransaction> transactions, {
    bool forceAll = false,
  }) async {
    var inserted = 0;
    var duplicatesSkipped = 0;
    var failed = 0;
    final errors = <String, String>{};

    for (final transaction in transactions) {
      if (transaction.isDuplicate && !forceAll) {
        duplicatesSkipped++;
        continue;
      }

      try {
        final databaseTransaction = await _taDao.insertTransaction(
          amount: transaction.amount,
          type: transaction.isIncome
              ? TransactionType.income
              : TransactionType.expense,
          shortDescription: transaction.shortDescription,
          longDescription: transaction.longDescription,
          transactionDate: transaction.date,
          source: TransactionSource.import,
        );

        if (transaction.categoryId != null) {
          await _taDao.assignCategory(
            transactionId: databaseTransaction.id,
            categoryId: transaction.categoryId!,
            assignmentSource: transaction.categoryOverridden
                ? AssignmentSource.manual
                : AssignmentSource.ai,
          );
        }

        inserted++;
      } catch (error) {
        failed++;
        errors[transaction.shortDescription] = error.toString();
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
    final allTransactions = await _taDao.getAllTransactions();

    return allTransactions.map((transaction) {
      final key = [
        transaction.transactionDate.toIso8601String(),
        transaction.amount.toString(),
        transaction.shortDescription.toLowerCase().trim(),
      ].join('|');

      final hash = sha256.convert(utf8.encode(key)).toString().substring(0, 16);

      return ExistingTransaction(
        date: transaction.transactionDate,
        amount: transaction.amount,
        deduplicationHash: hash,
      );
    }).toList();
  }
}
