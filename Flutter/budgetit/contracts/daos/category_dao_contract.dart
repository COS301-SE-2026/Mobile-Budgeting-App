import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart' show IconData;

abstract interface class CategoryDaoContract {
  Future<Category> insertCategory({
    required String name,
    required CategoryType type,
    IconData? icon,
    String? color,
    bool isDefault = false,
  });

  Future<Category?> getCategoryById(
    String id, {
    bool includeDeleted = false,
  });

  Future<List<Category>> getAllCategories({
    bool includeDeleted = false,
  });

  Future<List<Category>> getCategoriesByType(
    CategoryType type, {
    bool includeDeleted = false,
  });

  Future<Category> updateCategory(
    String id, {
    String? name,
    CategoryType? type,
    Value<IconData?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
    bool? isDefault,
  });

  Future<void> softDeleteCategory(String id);

  Future<void> hardDeleteCategory(String id);

  Future<void> restoreCategory(String id);

  Future<List<Category>> getChildren(String ancestorId);

  Future<List<Category>> getDescendants(String ancestorId);

  Future<void> moveCategory(String categoryId, String newParentId);
}
