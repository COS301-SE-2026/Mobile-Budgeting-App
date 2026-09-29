import 'dart:convert';
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../schema.dart';
import '../../models/import/statement_schema.dart';
import '../../services/import/schema_discovery_service.dart';

part 'schema_cache_dao.g.dart';

@DriftAccessor(tables: [StatementSchemaCache])
class SchemaCacheDao extends DatabaseAccessor<AppDatabase>
    with _$SchemaCacheDaoMixin
    implements SchemaCacheStore {
  SchemaCacheDao(super.db);
  DateTime _now() => DateTime.now().toUtc();



  @override
  Future<StatementSchema?> get(String fingerprint) async {
    final row = await (select(statementSchemaCache)..where((t) => t.fingerprint.equals(fingerprint))).getSingleOrNull();

    if (row == null) return null;

    List<String> skipPatterns;
    try {
      skipPatterns = (jsonDecode(row.skipLinePatterns) as List).map((e) => e.toString()).toList();
    } catch (_) {
      skipPatterns = const [];
    }

    return StatementSchema(
      signConvention: SignConvention.values.firstWhere((e) => e.name == row.signConvention, orElse: () => SignConvention.keywordBased),
      skipLinePatterns: skipPatterns,
    );
  }

  @override
  Future<void> put(String fingerprint, StatementSchema schema) async {
    final now = _now();
    await into(statementSchemaCache).insertOnConflictUpdate(
      StatementSchemaCacheCompanion.insert(
        fingerprint: fingerprint,
        signConvention: schema.signConvention.name,
        skipLinePatterns: jsonEncode(schema.skipLinePatterns),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> clearAll() => delete(statementSchemaCache).go();
}