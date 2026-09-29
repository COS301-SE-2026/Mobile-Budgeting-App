import 'package:budgetit/models/import/statement_schema.dart';

/// Persists the statement layout learned for a given bank format.
/// Working out a statement's sign convention can require asking the user, so
/// the result is cached against a fingerprint derived from the statement's
/// shape. A later import of the same format reuses it silently.
///
/// {@category Import}
abstract interface class SchemaCacheDaoContract {
  /// Returns the schema stored for [fingerprint], or `null` if this format
  /// has not been seen.
  /// A row whose stored sign convention is no longer recognised falls back to
  /// [SignConvention.keywordBased], and unreadable skip patterns fall back to
  /// an empty list, so a malformed row degrades rather than throwing.
  Future<StatementSchema?> get(String fingerprint);

  /// Stores [schema] under [fingerprint], replacing any existing entry.
  Future<void> put(String fingerprint, StatementSchema schema);

  /// Removes every cached schema.
  /// Use when learned layouts should be re-derived from scratch.
  Future<void> clearAll();
}
