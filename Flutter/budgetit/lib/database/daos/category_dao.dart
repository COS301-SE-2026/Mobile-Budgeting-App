// daos/category_dao.dart
import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../schema.dart';
import '../../utils/icon_mapper.dart';

part 'category_dao.g.dart';

/// Data access object for managing categories and their hierarchical relationships.
///
/// [CategoryDao] provides CRUD operations for categories as well as hierarchy
/// maintenance through the [CategoryClosure] table. Categories can be either
/// [CategoryType.income] or [CategoryType.expense].
///
/// Soft deletes are supported for categories, and [CategoryClosure] rows
/// (used for hierarchical queries) are cleaned up on hard delete.
///
/// Usage:
/// ```dart
/// final dao = CategoryDao(database);
/// final category = await dao.insertCategory(
///   name: 'Food',
///   type: CategoryType.expense,
/// );
/// ```
@DriftAccessor(
  tables: [
    Categories,
    CategoryClosure,
    TransactionCategoryMap,
    BudgetTemplates,
    BudgetPeriods,
  ],
)
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  /// Singleton UUID generator used to create unique identifiers for categories.
  final Uuid _uuid = const Uuid();

  /// Creates a new instance of [CategoryDao] backed by the given [AppDatabase].
  CategoryDao(super.db);

  /// Returns the current UTC time.
  DateTime _now() => DateTime.now().toUtc();

  /// Inserts a new category with the given [name] and [type].
  ///
  /// Generates a new UUID for the category and initializes its closure
  /// entry (self-reference with depth 0). Returns the persisted
  /// [Category] record.
  ///
  /// The [icon] is stored as a decimal codePoint string via [iconToDb].
  /// Read it back with `category.iconData` (from the [CategoryIconX] extension).
  ///
  /// - [name] - the display name of the category
  /// - [type] - whether this is an [CategoryType.income] or [CategoryType.expense] category
  /// - [icon] - optional [IconData] for the category; must be a Material Icon
  /// - [color] - optional hex color string for UI display (e.g. `'#FF5733'`)
  /// - [isDefault] - whether this is a built-in system category (defaults to `false`)
  Future<Category> insertCategory({
    required String name,
    required CategoryType type,
    IconData? icon,
    String? color,
    bool isDefault = false,
  }) async {
    final id = _uuid.v4();
    final now = _now();
    final companion = CategoriesCompanion.insert(
      id: id,
      name: name,
      type: type,
      icon: Value(icon != null ? iconToDb(icon) : null),
      color: Value(color),
      isDefault: isDefault,
      createdAt: now,
      updatedAt: now,
    );
    await db.transaction(() async {
      await into(categories).insert(companion);
      await into(categoryClosure).insert(
        CategoryClosureCompanion.insert(
          ancestorId: id,
          descendantId: id,
          depth: 0,
        ),
      );
    });
    return (select(categories)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Retrieves a single category by its [id].
  ///
  /// Returns `null` if no category exists with the given ID or if the
  /// category has been soft-deleted and [includeDeleted] is `false`.
  ///
  /// - [id] - the unique identifier of the category
  /// - [includeDeleted] - if `true`, includes soft-deleted categories
  ///   (defaults to `false`)
  Future<Category?> getCategoryById(String id, {bool includeDeleted = false}) {
    final q = select(categories)..where((t) => t.id.equals(id));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.getSingleOrNull();
  }

  /// Retrieves all categories.
  ///
  /// By default, soft-deleted categories are excluded. Use [includeDeleted]
  /// to include soft-deleted categories.
  ///
  /// - [includeDeleted] - if `true`, includes soft-deleted categories
  ///   (defaults to `false`)
  Future<List<Category>> getAllCategories({bool includeDeleted = false}) {
    final q = select(categories);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  /// Retrieves all categories of the given [type].
  ///
  /// By default, soft-deleted categories are excluded. Use [includeDeleted]
  /// to include soft-deleted categories.
  ///
  /// - [type] - the category type to filter by
  /// - [includeDeleted] - if `true`, includes soft-deleted categories
  ///   (defaults to `false`)
  Future<List<Category>> getCategoriesByType(
    CategoryType type, {
    bool includeDeleted = false,
  }) {
    final q = select(categories)..where((t) => t.type.equalsValue(type));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  /// Updates a category's fields.
  ///
  /// Only fields wrapped in a present [Value] are written to the database.
  /// Use `Value(null)` to explicitly clear a nullable field, and
  /// `const Value.absent()` (the default) to leave it unchanged.
  /// [Category.updatedAt] is always refreshed regardless of which fields
  /// are updated.
  ///
  /// The [icon] parameter accepts a [Value]-wrapped [IconData]. Conversion
  /// to the stored codePoint string is handled internally.
  ///
  /// Returns the updated [Category].
  ///
  /// Example — set an icon:
  /// ```dart
  /// await dao.updateCategory(id, icon: Value(Icons.savings_outlined));
  /// ```
  ///
  /// Example — clear an icon:
  /// ```dart
  /// await dao.updateCategory(id, icon: const Value(null));
  /// ```
  Future<Category> updateCategory(
    String id, {
    String? name,
    CategoryType? type,
    Value<IconData?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
    bool? isDefault,
  }) async {
    final companion = CategoriesCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      type: type != null ? Value(type) : const Value.absent(),
      icon: icon.present
          ? Value(icon.value != null ? iconToDb(icon.value!) : null)
          : const Value.absent(),
      color: color,
      isDefault: isDefault != null ? Value(isDefault) : const Value.absent(),
      updatedAt: Value(_now()),
    );
    await (update(categories)..where((t) => t.id.equals(id))).write(companion);
    return (select(categories)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Soft-deletes a category by marking [id] with a [deletedAt] timestamp.
  ///
  /// The category is not actually removed from the database. It will be
  /// excluded from query results unless [getCategoryById] or
  /// [getAllCategories] are called with [includeDeleted] = `true`.
  Future<void> softDeleteCategory(String id) async {
    final now = _now();
    await (update(categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  /// Hard-deletes a category and all dependent data.
  ///
  /// Within a single transaction:
  /// 1. Deletes [BudgetPeriods] for all budget templates that reference this category.
  /// 2. Deletes [BudgetTemplates] that reference this category.
  /// 3. Deletes [TransactionCategoryMap] entries that reference this category.
  /// 4. Removes all [CategoryClosure] entries where [id] is ancestor or descendant.
  /// 5. Deletes the category row itself.
  Future<void> hardDeleteCategory(String id) async {
    await db.transaction(() async {
      final templateIds = await (select(
        budgetTemplates,
      )..where((t) => t.categoryId.equals(id))).map((t) => t.id).get();
      if (templateIds.isNotEmpty) {
        await (delete(
          budgetPeriods,
        )..where((t) => t.templateId.isIn(templateIds))).go();
      }
      await (delete(
        budgetTemplates,
      )..where((t) => t.categoryId.equals(id))).go();
      await (delete(
        transactionCategoryMap,
      )..where((t) => t.categoryId.equals(id))).go();
      await (delete(categoryClosure)
            ..where((t) => t.ancestorId.equals(id) | t.descendantId.equals(id)))
          .go();
      await (delete(categories)..where((t) => t.id.equals(id))).go();
    });
  }

  /// Restores a soft-deleted category by clearing its [deletedAt] timestamp.
  ///
  /// The category becomes visible in queries again after restoration.
  Future<void> restoreCategory(String id) async {
    await (update(categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  }

  /// Returns child categories of the given [ancestorId].
  ///
  /// For the MVP (flat hierarchy), always returns an empty list.
  Future<List<Category>> getChildren(String ancestorId) async {
    // For MVP (flat hierarchy) returns empty.
    return [];
  }

  /// Returns all descendant categories of the given [ancestorId].
  ///
  /// For the MVP (flat hierarchy), always returns an empty list.
  Future<List<Category>> getDescendants(String ancestorId) async {
    // For MVP (flat hierarchy) returns empty.

    return [];
  }

  /// Moves a category to a new parent.
  ///
  /// For the MVP (flat hierarchy), this is a no-op. In the full
  /// implementation, this would update the closure table to maintain
  /// hierarchy integrity.
  Future<void> moveCategory(String categoryId, String newParentId) async {
    // TODO: implement closure maintenance
    //   For MVP (flat hierarchy) does nothing
  }
}
