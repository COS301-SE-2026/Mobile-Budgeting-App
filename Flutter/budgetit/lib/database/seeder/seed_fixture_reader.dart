part of 'database_seeder.dart';

/// Loads seed fixture rows into normalized entries.
abstract interface class SeedFixtureReader {
  /// Loads the fixture called `name`.
  ///
  /// Returned entries must use the expected keys for the seed scope.
  Future<List<Map<String, dynamic>>> loadFixtureEntries(String name);
}

/// Loads seed fixtures from JSON files in `assets/seeds`.
class JsonSeedFixtureReader implements SeedFixtureReader {
  /// Creates a reader for JSON seed fixture assets.
  JsonSeedFixtureReader();

  @override
  Future<List<Map<String, dynamic>>> loadFixtureEntries(String name) async {
    final raw = await rootBundle.loadString('assets/seeds/$name.json');
    final decoded = jsonDecode(raw) as List;

    final entries = decoded.map(
      (entry) => Map<String, dynamic>.from(entry as Map),
    );

    return entries.toList();
  }
}

String _getRequiredFixtureText(Map<String, dynamic> entry, String key) {
  final value = entry[key];

  if (value is! String) {
    throw FormatException(
      'Invalid value for key "$key" in seed fixture: $entry',
    );
  }

  final isBlank = value.trim().isEmpty;

  if (isBlank) {
    throw FormatException(
      'Invalid value for key "$key" in seed fixture: $entry',
    );
  }

  return value;
}

Decimal _getFixtureAmount(Map<String, dynamic> entry) {
  final amount = Decimal.parse(_getRequiredFixtureText(entry, 'amount'));

  if (amount <= Decimal.zero) {
    throw FormatException('Invalid amount: $entry');
  }

  return amount;
}

T _getFixtureEnumValue<T extends Enum>(
  List<T> values,
  Map<String, dynamic> entry,
  String key,
) {
  final value = _getRequiredFixtureText(entry, key);

  for (final item in values) {
    if (item.name == value) {
      return item;
    }
  }

  throw FormatException(
    'Invalid value "$value" for key "$key" in seed fixture',
  );
}

String _getFixtureCurrency(Map<String, dynamic> entry) {
  final hasCurrency = entry['currency'] != null;

  if (hasCurrency) {
    return _getRequiredFixtureText(entry, 'currency');
  }

  return 'ZAR';
}
