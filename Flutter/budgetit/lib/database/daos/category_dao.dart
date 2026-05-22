// daos/category_dao.dart
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../schema.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories, CategoryClosure])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  final Uuid _uuid = const Uuid();

  CategoryDao(super.db);

  DateTime _now() => DateTime.now().toUtc();

  Future<Category> insertCategory({
    required String name,
    required CategoryType type,
    String? icon,
    String? color,
    bool isDefault = false,
  }) async {
    final id = _uuid.v4();
    final now = _now();
    final companion = CategoriesCompanion.insert(
      id: id,
      name: name,
      type: type,
      icon: Value(icon),
      color: Value(color),
      isDefault: isDefault,
      createdAt: now,
      updatedAt: now,
    );
    await into(categories).insert(companion);
    await into(categoryClosure).insert(
      CategoryClosureCompanion.insert(
        ancestorId: id,
        descendantId: id,
        depth: 0,
      ),
    );
    return (select(categories)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<Category?> getCategoryById(String id, {bool includeDeleted = false}) {
    final q = select(categories)..where((t) => t.id.equals(id));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.getSingleOrNull();
  }

  Future<List<Category>> getAllCategories({bool includeDeleted = false}) {
    final q = select(categories);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  Future<List<Category>> getCategoriesByType(
    CategoryType type, {
    bool includeDeleted = false,
  }) {
    final q = select(categories)..where((t) => t.type.equalsValue(type));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  Future<Category> updateCategory(
    String id, {
    String? name,
    CategoryType? type,
    String? icon,
    String? color,
    bool? isDefault,
  }) async {
    final companion = CategoriesCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      type: type != null ? Value(type) : const Value.absent(),
      icon: icon != null ? Value(icon) : const Value.absent(),
      color: color != null ? Value(color) : const Value.absent(),
      isDefault: isDefault != null ? Value(isDefault) : const Value.absent(),
      updatedAt: Value(_now()),
    );
    await (update(categories)..where((t) => t.id.equals(id))).write(companion);
    return (select(categories)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> softDeleteCategory(String id) async {
    final now = _now();
    await (update(categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<void> hardDeleteCategory(String id) async {
    // Delete all closure rows that involve this category
    await (delete(
      categoryClosure,
    )..where((t) => t.ancestorId.equals(id) | t.descendantId.equals(id))).go();
    await (delete(categories)..where((t) => t.id.equals(id))).go();
  }

  Future<void> restoreCategory(String id) async {
    await (update(categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<List<Category>> getChildren(String ancestorId) async {
    // For MVP (flat hierarchy) returns empty.
    return [];
  }

  Future<List<Category>> getDescendants(String ancestorId) async {
    // For MVP (flat hierarchy) returns empty.

    return [];
  }

  Future<void> moveCategory(String categoryId, String newParentId) async {
    // TODO: implement closure maintenance
    //   For MVP (flat hierarchy) does nothing
  }
}
