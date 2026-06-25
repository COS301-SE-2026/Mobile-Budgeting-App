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

Category categoryFixture({
  String id = 'cat-1',
  String name = 'General',
  CategoryType type = CategoryType.expense,
  String? icon,
  String? color,
  bool isDefault = false,
  DateTime? createdAt,
  DateTime? updatedAt,
  DateTime? deletedAt,
}) {
  final now = DateTime(2026, 5, 18);
  return Category(
    id: id,
    name: name,
    type: type,
    icon: icon,
    color: color,
    isDefault: isDefault,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
    deletedAt: deletedAt,
  );
}
