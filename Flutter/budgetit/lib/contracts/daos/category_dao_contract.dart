import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart' show IconData;

/// Data access for spending and income categories.
/// Categories are stored with a closure table so a hierarchy can be added
/// later; the MVP uses a flat list, so [getChildren], [getDescendants] and
/// [moveCategory] are present but inert.
///
/// Deletion is soft by default and cascades by clearing references from
/// transaction mappings and recurring transactions, rather than deleting
/// them.
/// Nullable fields are updated through drift's [Value] wrapper so that
/// "leave unchanged" stays distinguishable from "set to null".
///
/// {@category DAOs}
abstract interface class CategoryDaoContract {
  /// Inserts a category and returns the persisted record.
  /// Generates a UUID and initialises the category's closure entry as a
  /// self-reference at depth 0.
  ///
  ///  [name] : display name
  ///  [type] : whether the category is for income or expenses
  ///  [icon] : optional Material icon, stored as its code point
  ///  [color] : optional hex colour string for the UI, e.g. '#FF5733'
  ///  [isDefault] : marks a built-in category seeded by the app
  Future<Category> insertCategory({
    required String name,
    required CategoryType type,
    IconData? icon,
    String? color,
    bool isDefault = false,
  });

  /// Retrieves a category by [id].
  /// Returns 'null' if none exists, or if it is soft-deleted and
  /// [includeDeleted] is 'false'.
  Future<Category?> getCategoryById(
    String id, {
    bool includeDeleted = false,
  });

  /// Retrieves all categories.
  /// Soft-deleted categories are excluded unless [includeDeleted] is 'true'.
  Future<List<Category>> getAllCategories({
    bool includeDeleted = false,
  });

  /// Retrieves all categories of the given [type].
  /// Soft-deleted categories are excluded unless [includeDeleted] is 'true'.
  Future<List<Category>> getCategoriesByType(
    CategoryType type, {
    bool includeDeleted = false,
  });

  /// Updates the supplied fields of category [id] and returns the updated
  /// record.
  /// [name], [type] and [isDefault] are written when non-'null'. [icon] and
  /// [color] are nullable columns, so they take a [Value]: omit it to leave
  /// the column alone, or pass 'Value(null)' to clear it.
  ///
  /// '''dart
  /// await dao.updateCategory(id, icon: Value(Icons.savings_outlined));
  /// await dao.updateCategory(id, icon: const Value(null));
  /// '''
  Future<Category> updateCategory(
    String id, {
    String? name,
    CategoryType? type,
    Value<IconData?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
    bool? isDefault,
  });

  /// Soft-deletes category [id] by stamping its deleted-at timestamp.
  /// Cascades by clearing the category reference on any transaction mappings
  /// and recurring transactions that used it, so those records survive
  /// uncategorised. Reverse with [restoreCategory].
  Future<void> softDeleteCategory(String id);

  /// Permanently removes category [id].
  /// This cannot be undone; prefer [softDeleteCategory] for user-facing
  /// deletes.
  Future<void> hardDeleteCategory(String id);

  /// Restores a soft-deleted category by clearing its deleted-at timestamp.
  Future<void> restoreCategory(String id);

  /// Returns the direct children of [ancestorId].
  /// The MVP hierarchy is flat, so this always returns an empty list.
  Future<List<Category>> getChildren(String ancestorId);

  /// Returns every descendant of [ancestorId] at any depth.
  /// The MVP hierarchy is flat, so this always returns an empty list.
  Future<List<Category>> getDescendants(String ancestorId);

  /// Reparents [categoryId] under [newParentId].
  /// The MVP hierarchy is flat, so this is a no-op. A full implementation
  /// would rewrite the closure table to keep the hierarchy consistent.
  Future<void> moveCategory(String categoryId, String newParentId);
}
