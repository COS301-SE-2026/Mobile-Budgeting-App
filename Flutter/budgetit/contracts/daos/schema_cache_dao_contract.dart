import 'package:budgetit/models/import/statement_schema.dart';

abstract interface class SchemaCacheDaoContract {
  Future<StatementSchema?> get(String fingerprint);
  Future<void> put(String fingerprint, StatementSchema schema);
  Future<int> clearAll();
}
