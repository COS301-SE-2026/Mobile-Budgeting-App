import 'package:decimal/decimal.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';

Transaction transactionFixture({
  String id = 'txn-1',
  Decimal? amount,
  TransactionType type = TransactionType.expense,
  String shortDescription = 'Test transaction',
  String? longDescription,
  DateTime? transactionDate,
  DateTime? createdAt,
  DateTime? updatedAt,
  DateTime? deletedAt,
  TransactionSource source = TransactionSource.manual,
  String currency = 'ZAR',
}) {
  final date = transactionDate ?? DateTime(2026, 5, 18);
  return Transaction(
    id: id,
    amount: amount ?? Decimal.parse('10.00'),
    type: type,
    shortDescription: shortDescription,
    longDescription: longDescription,
    transactionDate: date,
    createdAt: createdAt ?? date,
    updatedAt: updatedAt ?? date,
    deletedAt: deletedAt,
    source: source,
    currency: currency,
  );
}
