/// Utilities for persisting Flutter [IconData] values in the SQLite database.
///
/// The [Categories] table stores icons as a plain decimal string containing
/// the icon's Unicode code point (e.g. `"983091"`). This library provides the
/// two conversion functions that the [CategoryDao] uses internally, plus a
/// convenience extension on the Drift-generated [Category] model so that UI
/// code never needs to call the raw converters directly.
///
/// ## Storage format
///
/// Only Material Icons (`fontFamily: 'MaterialIcons'`) are supported.
/// The stored value is `IconData.codePoint.toString()` — a decimal integer
/// string. No font-family information is stored because the app exclusively
/// uses the built-in Material Icons font.
///
/// ## Typical usage (UI layer)
///
/// ```dart
/// // Saving — pass the IconData directly to the DAO:
/// await categoryDao.insertCategory(
///   name: 'Dining',
///   type: CategoryType.expense,
///   icon: Icons.restaurant,
/// );
///
/// // Reading — use the extension getter:
/// final iconWidget = Icon(category.iconData ?? Icons.category_outlined);
/// ```
library;

import 'package:flutter/widgets.dart';
import 'package:budgetit/database/app_database.dart';

/// Converts [icon] to a decimal codePoint string suitable for storage in the
/// `categories.icon` SQLite column.
///
/// Only Material Icons (`fontFamily: 'MaterialIcons'`) are accepted. Passing
/// an icon from another font family will trigger an assertion failure in debug
/// mode (silently ignored in release builds).
///
/// Use this when writing to the database. Pair with [iconFromDb] to round-trip
/// the value. The [CategoryDao] calls this internally, so UI code typically
/// does not need to call it directly.
///
/// Example:
/// ```dart
/// iconToDb(Icons.restaurant) // → "983091"
/// ```
String iconToDb(IconData icon) {
  assert(
    icon.fontFamily == 'MaterialIcons',
    'iconToDb only supports Material Icons (fontFamily "MaterialIcons"), '
    'got "${icon.fontFamily}".',
  );
  return icon.codePoint.toString();
}

/// Reconstructs a Material [IconData] from the decimal codePoint [code]
/// stored in the `categories.icon` SQLite column.
///
/// Returns an [IconData] with `fontFamily` set to `'MaterialIcons'`, or
/// `null` if [code] is not a valid decimal integer string. The null return
/// acts as a safe recovery path for malformed or legacy data in the database.
///
/// The [CategoryDao] calls this internally via the [CategoryIconX] extension;
/// UI code should prefer `category.iconData` over calling this directly.
///
/// Example:
/// ```dart
/// iconFromDb("983091")   // → IconData(983091, fontFamily: 'MaterialIcons')
/// iconFromDb("bad")      // → null
/// ```
IconData? iconFromDb(String code) {
  final cp = int.tryParse(code);
  if (cp == null) return null;
  // ignore: non_const_argument_for_const_parameter
  return IconData(cp, fontFamily: 'MaterialIcons');
}

/// Extends the Drift-generated [Category] model with an [iconData] getter
/// that converts the raw stored string back to a Flutter [IconData].
///
/// This keeps icon-related conversion out of the UI layer — widgets read
/// `category.iconData` without knowing about the underlying storage format.
///
/// Returns `null` when no icon has been assigned to the category.
///
/// Example:
/// ```dart
/// Icon(category.iconData ?? Icons.category_outlined)
/// ```
extension CategoryIconX on Category {
  /// The category's icon as a Flutter [IconData], or `null` if none is set.
  IconData? get iconData => icon != null ? iconFromDb(icon!) : null;
}
