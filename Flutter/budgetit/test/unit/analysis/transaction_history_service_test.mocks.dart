

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i9;

import 'package:budgetit/database/app_database.dart' as _i7;
import 'package:budgetit/database/daos/budget_dao.dart' as _i5;
import 'package:budgetit/database/daos/category_dao.dart' as _i3;
import 'package:budgetit/database/daos/settings_dao.dart' as _i6;
import 'package:budgetit/database/daos/transaction_dao.dart' as _i4;
import 'package:budgetit/database/schema.dart' as _i12;
import 'package:decimal/decimal.dart' as _i11;
import 'package:drift/drift.dart' as _i2;
import 'package:drift/src/runtime/executor/stream_queries.dart' as _i8;
import 'package:flutter/widgets.dart' as _i13;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i10;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class
// ignore_for_file: invalid_use_of_internal_member

class _FakeMigrationStrategy_0 extends _i1.SmartFake
    implements _i2.MigrationStrategy {
  _FakeMigrationStrategy_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeCategoryDao_1 extends _i1.SmartFake implements _i3.CategoryDao {
  _FakeCategoryDao_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeTransactionDao_2 extends _i1.SmartFake
    implements _i4.TransactionDao {
  _FakeTransactionDao_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeBudgetDao_3 extends _i1.SmartFake implements _i5.BudgetDao {
  _FakeBudgetDao_3(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeSettingsDao_4 extends _i1.SmartFake implements _i6.SettingsDao {
  _FakeSettingsDao_4(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _Fake$AppDatabaseManager_5 extends _i1.SmartFake
    implements _i7.$AppDatabaseManager {
  _Fake$AppDatabaseManager_5(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _Fake$CategoriesTable_6 extends _i1.SmartFake
    implements _i7.$CategoriesTable {
  _Fake$CategoriesTable_6(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _Fake$CategoryClosureTable_7 extends _i1.SmartFake
    implements _i7.$CategoryClosureTable {
  _Fake$CategoryClosureTable_7(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _Fake$TransactionsTable_8 extends _i1.SmartFake
    implements _i7.$TransactionsTable {
  _Fake$TransactionsTable_8(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _Fake$TransactionCategoryMapTable_9 extends _i1.SmartFake
    implements _i7.$TransactionCategoryMapTable {
  _Fake$TransactionCategoryMapTable_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(parent, parentInvocation);
}

class _Fake$BudgetTemplatesTable_10 extends _i1.SmartFake
    implements _i7.$BudgetTemplatesTable {
  _Fake$BudgetTemplatesTable_10(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _Fake$BudgetPeriodsTable_11 extends _i1.SmartFake
    implements _i7.$BudgetPeriodsTable {
  _Fake$BudgetPeriodsTable_11(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _Fake$AppSettingsTable_12 extends _i1.SmartFake
    implements _i7.$AppSettingsTable {
  _Fake$AppSettingsTable_12(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeGeneratedDatabase_13 extends _i1.SmartFake
    implements _i2.GeneratedDatabase {
  _FakeGeneratedDatabase_13(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeDriftDatabaseOptions_14 extends _i1.SmartFake
    implements _i2.DriftDatabaseOptions {
  _FakeDriftDatabaseOptions_14(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeStreamQueryUpdateRules_15 extends _i1.SmartFake
    implements _i2.StreamQueryUpdateRules {
  _FakeStreamQueryUpdateRules_15(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeDatabaseConnection_16 extends _i1.SmartFake
    implements _i2.DatabaseConnection {
  _FakeDatabaseConnection_16(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeQueryExecutor_17 extends _i1.SmartFake implements _i2.QueryExecutor {
  _FakeQueryExecutor_17(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeStreamQueryStore_18 extends _i1.SmartFake
    implements _i8.StreamQueryStore {
  _FakeStreamQueryStore_18(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeDatabaseConnectionUser_19 extends _i1.SmartFake
    implements _i2.DatabaseConnectionUser {
  _FakeDatabaseConnectionUser_19(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeMigrator_20 extends _i1.SmartFake implements _i2.Migrator {
  _FakeMigrator_20(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeFuture_21<T> extends _i1.SmartFake implements _i9.Future<T> {
  _FakeFuture_21(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeInsertStatement_22<T1 extends _i2.Table, D1> extends _i1.SmartFake
    implements _i2.InsertStatement<T1, D1> {
  _FakeInsertStatement_22(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeUpdateStatement_23<T extends _i2.Table, D> extends _i1.SmartFake
    implements _i2.UpdateStatement<T, D> {
  _FakeUpdateStatement_23(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeSimpleSelectStatement_24<T1 extends _i2.HasResultSet, D>
    extends _i1.SmartFake
    implements _i2.SimpleSelectStatement<T1, D> {
  _FakeSimpleSelectStatement_24(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeJoinedSelectStatement_25<FirstT extends _i2.HasResultSet, FirstD>
    extends _i1.SmartFake
    implements _i2.JoinedSelectStatement<FirstT, FirstD> {
  _FakeJoinedSelectStatement_25(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeBaseSelectStatement_26<Row> extends _i1.SmartFake
    implements _i2.BaseSelectStatement<Row> {
  _FakeBaseSelectStatement_26(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeDeleteStatement_27<T1 extends _i2.Table, D1> extends _i1.SmartFake
    implements _i2.DeleteStatement<T1, D1> {
  _FakeDeleteStatement_27(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeSelectable_28<T> extends _i1.SmartFake implements _i2.Selectable<T> {
  _FakeSelectable_28(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeGenerationContext_29 extends _i1.SmartFake
    implements _i2.GenerationContext {
  _FakeGenerationContext_29(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeAppDatabase_30 extends _i1.SmartFake implements _i7.AppDatabase {
  _FakeAppDatabase_30(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeTransactionDaoManager_31 extends _i1.SmartFake
    implements _i4.TransactionDaoManager {
  _FakeTransactionDaoManager_31(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeTransaction_32 extends _i1.SmartFake implements _i7.Transaction {
  _FakeTransaction_32(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeTransactionCategoryMapData_33 extends _i1.SmartFake
    implements _i7.TransactionCategoryMapData {
  _FakeTransactionCategoryMapData_33(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeCategoryDaoManager_34 extends _i1.SmartFake
    implements _i3.CategoryDaoManager {
  _FakeCategoryDaoManager_34(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeCategory_35 extends _i1.SmartFake implements _i7.Category {
  _FakeCategory_35(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [AppDatabase].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppDatabase extends _i1.Mock implements _i7.AppDatabase {
  MockAppDatabase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get schemaVersion =>
      (super.noSuchMethod(Invocation.getter(#schemaVersion), returnValue: 0)
          as int);

  @override
  _i2.MigrationStrategy get migration =>
      (super.noSuchMethod(
            Invocation.getter(#migration),
            returnValue: _FakeMigrationStrategy_0(
              this,
              Invocation.getter(#migration),
            ),
          )
          as _i2.MigrationStrategy);

  @override
  _i3.CategoryDao get categoryDao =>
      (super.noSuchMethod(
            Invocation.getter(#categoryDao),
            returnValue: _FakeCategoryDao_1(
              this,
              Invocation.getter(#categoryDao),
            ),
          )
          as _i3.CategoryDao);

  @override
  _i4.TransactionDao get transactionDao =>
      (super.noSuchMethod(
            Invocation.getter(#transactionDao),
            returnValue: _FakeTransactionDao_2(
              this,
              Invocation.getter(#transactionDao),
            ),
          )
          as _i4.TransactionDao);

  @override
  _i5.BudgetDao get budgetDao =>
      (super.noSuchMethod(
            Invocation.getter(#budgetDao),
            returnValue: _FakeBudgetDao_3(this, Invocation.getter(#budgetDao)),
          )
          as _i5.BudgetDao);

  @override
  _i6.SettingsDao get settingsDao =>
      (super.noSuchMethod(
            Invocation.getter(#settingsDao),
            returnValue: _FakeSettingsDao_4(
              this,
              Invocation.getter(#settingsDao),
            ),
          )
          as _i6.SettingsDao);

  @override
  _i7.$AppDatabaseManager get managers =>
      (super.noSuchMethod(
            Invocation.getter(#managers),
            returnValue: _Fake$AppDatabaseManager_5(
              this,
              Invocation.getter(#managers),
            ),
          )
          as _i7.$AppDatabaseManager);

  @override
  _i7.$CategoriesTable get categories =>
      (super.noSuchMethod(
            Invocation.getter(#categories),
            returnValue: _Fake$CategoriesTable_6(
              this,
              Invocation.getter(#categories),
            ),
          )
          as _i7.$CategoriesTable);

  @override
  _i7.$CategoryClosureTable get categoryClosure =>
      (super.noSuchMethod(
            Invocation.getter(#categoryClosure),
            returnValue: _Fake$CategoryClosureTable_7(
              this,
              Invocation.getter(#categoryClosure),
            ),
          )
          as _i7.$CategoryClosureTable);

  @override
  _i7.$TransactionsTable get transactions =>
      (super.noSuchMethod(
            Invocation.getter(#transactions),
            returnValue: _Fake$TransactionsTable_8(
              this,
              Invocation.getter(#transactions),
            ),
          )
          as _i7.$TransactionsTable);

  @override
  _i7.$TransactionCategoryMapTable get transactionCategoryMap =>
      (super.noSuchMethod(
            Invocation.getter(#transactionCategoryMap),
            returnValue: _Fake$TransactionCategoryMapTable_9(
              this,
              Invocation.getter(#transactionCategoryMap),
            ),
          )
          as _i7.$TransactionCategoryMapTable);

  @override
  _i7.$BudgetTemplatesTable get budgetTemplates =>
      (super.noSuchMethod(
            Invocation.getter(#budgetTemplates),
            returnValue: _Fake$BudgetTemplatesTable_10(
              this,
              Invocation.getter(#budgetTemplates),
            ),
          )
          as _i7.$BudgetTemplatesTable);

  @override
  _i7.$BudgetPeriodsTable get budgetPeriods =>
      (super.noSuchMethod(
            Invocation.getter(#budgetPeriods),
            returnValue: _Fake$BudgetPeriodsTable_11(
              this,
              Invocation.getter(#budgetPeriods),
            ),
          )
          as _i7.$BudgetPeriodsTable);

  @override
  _i7.$AppSettingsTable get appSettings =>
      (super.noSuchMethod(
            Invocation.getter(#appSettings),
            returnValue: _Fake$AppSettingsTable_12(
              this,
              Invocation.getter(#appSettings),
            ),
          )
          as _i7.$AppSettingsTable);

  @override
  Iterable<_i2.TableInfo<_i2.Table, Object?>> get allTables =>
      (super.noSuchMethod(
            Invocation.getter(#allTables),
            returnValue: <_i2.TableInfo<_i2.Table, Object?>>[],
          )
          as Iterable<_i2.TableInfo<_i2.Table, Object?>>);

  @override
  List<_i2.DatabaseSchemaEntity> get allSchemaEntities =>
      (super.noSuchMethod(
            Invocation.getter(#allSchemaEntities),
            returnValue: <_i2.DatabaseSchemaEntity>[],
          )
          as List<_i2.DatabaseSchemaEntity>);

  @override
  _i2.GeneratedDatabase get attachedDatabase =>
      (super.noSuchMethod(
            Invocation.getter(#attachedDatabase),
            returnValue: _FakeGeneratedDatabase_13(
              this,
              Invocation.getter(#attachedDatabase),
            ),
          )
          as _i2.GeneratedDatabase);

  @override
  _i2.DriftDatabaseOptions get options =>
      (super.noSuchMethod(
            Invocation.getter(#options),
            returnValue: _FakeDriftDatabaseOptions_14(
              this,
              Invocation.getter(#options),
            ),
          )
          as _i2.DriftDatabaseOptions);

  @override
  _i2.StreamQueryUpdateRules get streamUpdateRules =>
      (super.noSuchMethod(
            Invocation.getter(#streamUpdateRules),
            returnValue: _FakeStreamQueryUpdateRules_15(
              this,
              Invocation.getter(#streamUpdateRules),
            ),
          )
          as _i2.StreamQueryUpdateRules);

  @override
  _i2.DatabaseConnection get connection =>
      (super.noSuchMethod(
            Invocation.getter(#connection),
            returnValue: _FakeDatabaseConnection_16(
              this,
              Invocation.getter(#connection),
            ),
          )
          as _i2.DatabaseConnection);

  @override
  _i2.SqlTypes get typeMapping =>
      (super.noSuchMethod(
            Invocation.getter(#typeMapping),
            returnValue: _i10.dummyValue<_i2.SqlTypes>(
              this,
              Invocation.getter(#typeMapping),
            ),
          )
          as _i2.SqlTypes);

  @override
  _i2.QueryExecutor get executor =>
      (super.noSuchMethod(
            Invocation.getter(#executor),
            returnValue: _FakeQueryExecutor_17(
              this,
              Invocation.getter(#executor),
            ),
          )
          as _i2.QueryExecutor);

  @override
  _i8.StreamQueryStore get streamQueries =>
      (super.noSuchMethod(
            Invocation.getter(#streamQueries),
            returnValue: _FakeStreamQueryStore_18(
              this,
              Invocation.getter(#streamQueries),
            ),
          )
          as _i8.StreamQueryStore);

  @override
  _i2.DatabaseConnectionUser get resolvedEngine =>
      (super.noSuchMethod(
            Invocation.getter(#resolvedEngine),
            returnValue: _FakeDatabaseConnectionUser_19(
              this,
              Invocation.getter(#resolvedEngine),
            ),
          )
          as _i2.DatabaseConnectionUser);

  @override
  _i2.Migrator createMigrator() =>
      (super.noSuchMethod(
            Invocation.method(#createMigrator, []),
            returnValue: _FakeMigrator_20(
              this,
              Invocation.method(#createMigrator, []),
            ),
          )
          as _i2.Migrator);

  @override
  _i9.Future<void> beforeOpen(
    _i2.QueryExecutor? executor,
    _i2.OpeningDetails? details,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#beforeOpen, [executor, details]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<void> close() =>
      (super.noSuchMethod(
            Invocation.method(#close, []),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<Ret> computeWithDatabase<Ret, DB extends _i2.GeneratedDatabase>({
    required _i9.FutureOr<Ret> Function(DB)? computation,
    required DB Function(_i2.DatabaseConnection)? connect,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#computeWithDatabase, [], {
              #computation: computation,
              #connect: connect,
            }),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<Ret>(
                    this,
                    Invocation.method(#computeWithDatabase, [], {
                      #computation: computation,
                      #connect: connect,
                    }),
                  ),
                  (Ret v) => _i9.Future<Ret>.value(v),
                ) ??
                _FakeFuture_21<Ret>(
                  this,
                  Invocation.method(#computeWithDatabase, [], {
                    #computation: computation,
                    #connect: connect,
                  }),
                ),
          )
          as _i9.Future<Ret>);

  @override
  _i9.Stream<T> createStream<T extends Object>(
    _i8.QueryStreamFetcher<T>? stmt,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#createStream, [stmt]),
            returnValue: _i9.Stream<T>.empty(),
          )
          as _i9.Stream<T>);

  @override
  T alias<T, D>(_i2.ResultSetImplementation<T, D>? table, String? alias) =>
      (super.noSuchMethod(
            Invocation.method(#alias, [table, alias]),
            returnValue: _i10.dummyValue<T>(
              this,
              Invocation.method(#alias, [table, alias]),
            ),
          )
          as T);

  @override
  void markTablesUpdated(Iterable<_i2.TableInfo<_i2.Table, dynamic>>? tables) =>
      super.noSuchMethod(
        Invocation.method(#markTablesUpdated, [tables]),
        returnValueForMissingStub: null,
      );

  @override
  void notifyUpdates(Set<_i2.TableUpdate>? updates) => super.noSuchMethod(
    Invocation.method(#notifyUpdates, [updates]),
    returnValueForMissingStub: null,
  );

  @override
  _i9.Stream<Set<_i2.TableUpdate>> tableUpdates([
    _i2.TableUpdateQuery? query = const _i2.TableUpdateQuery.any(),
  ]) =>
      (super.noSuchMethod(
            Invocation.method(#tableUpdates, [query]),
            returnValue: _i9.Stream<Set<_i2.TableUpdate>>.empty(),
          )
          as _i9.Stream<Set<_i2.TableUpdate>>);

  @override
  _i9.Future<T> doWhenOpened<T>(
    _i9.FutureOr<T> Function(_i2.QueryExecutor)? fn,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#doWhenOpened, [fn]),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(#doWhenOpened, [fn]),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(this, Invocation.method(#doWhenOpened, [fn])),
          )
          as _i9.Future<T>);

  @override
  _i2.InsertStatement<T, D> into<T extends _i2.Table, D>(
    _i2.TableInfo<T, D>? table,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#into, [table]),
            returnValue: _FakeInsertStatement_22<T, D>(
              this,
              Invocation.method(#into, [table]),
            ),
          )
          as _i2.InsertStatement<T, D>);

  @override
  _i2.UpdateStatement<Tbl, R> update<Tbl extends _i2.Table, R>(
    _i2.TableInfo<Tbl, R>? table,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#update, [table]),
            returnValue: _FakeUpdateStatement_23<Tbl, R>(
              this,
              Invocation.method(#update, [table]),
            ),
          )
          as _i2.UpdateStatement<Tbl, R>);

  @override
  _i2.SimpleSelectStatement<T, R> select<T extends _i2.HasResultSet, R>(
    _i2.ResultSetImplementation<T, R>? table, {
    bool? distinct = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#select, [table], {#distinct: distinct}),
            returnValue: _FakeSimpleSelectStatement_24<T, R>(
              this,
              Invocation.method(#select, [table], {#distinct: distinct}),
            ),
          )
          as _i2.SimpleSelectStatement<T, R>);

  @override
  _i2.JoinedSelectStatement<T, R> selectOnly<T extends _i2.HasResultSet, R>(
    _i2.ResultSetImplementation<T, R>? table, {
    bool? distinct = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#selectOnly, [table], {#distinct: distinct}),
            returnValue: _FakeJoinedSelectStatement_25<T, R>(
              this,
              Invocation.method(#selectOnly, [table], {#distinct: distinct}),
            ),
          )
          as _i2.JoinedSelectStatement<T, R>);

  @override
  _i2.BaseSelectStatement<_i2.TypedResult> selectExpressions(
    Iterable<_i2.Expression<Object>>? columns,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#selectExpressions, [columns]),
            returnValue: _FakeBaseSelectStatement_26<_i2.TypedResult>(
              this,
              Invocation.method(#selectExpressions, [columns]),
            ),
          )
          as _i2.BaseSelectStatement<_i2.TypedResult>);

  @override
  _i2.DeleteStatement<T, D> delete<T extends _i2.Table, D>(
    _i2.TableInfo<T, D>? table,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#delete, [table]),
            returnValue: _FakeDeleteStatement_27<T, D>(
              this,
              Invocation.method(#delete, [table]),
            ),
          )
          as _i2.DeleteStatement<T, D>);

  @override
  _i9.Future<int> customUpdate(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? updates,
    _i2.UpdateKind? updateKind,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customUpdate,
              [query],
              {
                #variables: variables,
                #updates: updates,
                #updateKind: updateKind,
              },
            ),
            returnValue: _i9.Future<int>.value(0),
          )
          as _i9.Future<int>);

  @override
  _i9.Future<int> customInsert(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? updates,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customInsert,
              [query],
              {#variables: variables, #updates: updates},
            ),
            returnValue: _i9.Future<int>.value(0),
          )
          as _i9.Future<int>);

  @override
  _i9.Future<List<_i2.QueryRow>> customWriteReturning(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? updates,
    _i2.UpdateKind? updateKind,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customWriteReturning,
              [query],
              {
                #variables: variables,
                #updates: updates,
                #updateKind: updateKind,
              },
            ),
            returnValue: _i9.Future<List<_i2.QueryRow>>.value(<_i2.QueryRow>[]),
          )
          as _i9.Future<List<_i2.QueryRow>>);

  @override
  _i2.Selectable<_i2.QueryRow> customSelect(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? readsFrom = const {},
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customSelect,
              [query],
              {#variables: variables, #readsFrom: readsFrom},
            ),
            returnValue: _FakeSelectable_28<_i2.QueryRow>(
              this,
              Invocation.method(
                #customSelect,
                [query],
                {#variables: variables, #readsFrom: readsFrom},
              ),
            ),
          )
          as _i2.Selectable<_i2.QueryRow>);

  @override
  _i2.Selectable<_i2.QueryRow> customSelectQuery(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? readsFrom = const {},
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customSelectQuery,
              [query],
              {#variables: variables, #readsFrom: readsFrom},
            ),
            returnValue: _FakeSelectable_28<_i2.QueryRow>(
              this,
              Invocation.method(
                #customSelectQuery,
                [query],
                {#variables: variables, #readsFrom: readsFrom},
              ),
            ),
          )
          as _i2.Selectable<_i2.QueryRow>);

  @override
  _i9.Future<void> customStatement(String? statement, [List<dynamic>? args]) =>
      (super.noSuchMethod(
            Invocation.method(#customStatement, [statement, args]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<T> transaction<T>(
    _i9.Future<T> Function()? action, {
    bool? requireNew = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #transaction,
              [action],
              {#requireNew: requireNew},
            ),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(
                      #transaction,
                      [action],
                      {#requireNew: requireNew},
                    ),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(
                  this,
                  Invocation.method(
                    #transaction,
                    [action],
                    {#requireNew: requireNew},
                  ),
                ),
          )
          as _i9.Future<T>);

  @override
  _i9.Future<T> exclusively<T>(_i9.Future<T> Function()? action) =>
      (super.noSuchMethod(
            Invocation.method(#exclusively, [action]),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(#exclusively, [action]),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(
                  this,
                  Invocation.method(#exclusively, [action]),
                ),
          )
          as _i9.Future<T>);

  @override
  _i9.Future<void> batch(_i9.FutureOr<void> Function(_i2.Batch)? runInBatch) =>
      (super.noSuchMethod(
            Invocation.method(#batch, [runInBatch]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<T> runWithInterceptor<T>(
    _i9.Future<T> Function()? action, {
    required _i2.QueryInterceptor? interceptor,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #runWithInterceptor,
              [action],
              {#interceptor: interceptor},
            ),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(
                      #runWithInterceptor,
                      [action],
                      {#interceptor: interceptor},
                    ),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(
                  this,
                  Invocation.method(
                    #runWithInterceptor,
                    [action],
                    {#interceptor: interceptor},
                  ),
                ),
          )
          as _i9.Future<T>);

  @override
  _i2.GenerationContext $write(
    _i2.Component? component, {
    bool? hasMultipleTables,
    int? startIndex,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #$write,
              [component],
              {#hasMultipleTables: hasMultipleTables, #startIndex: startIndex},
            ),
            returnValue: _FakeGenerationContext_29(
              this,
              Invocation.method(
                #$write,
                [component],
                {
                  #hasMultipleTables: hasMultipleTables,
                  #startIndex: startIndex,
                },
              ),
            ),
          )
          as _i2.GenerationContext);

  @override
  _i2.GenerationContext $writeInsertable(
    _i2.TableInfo<_i2.Table, dynamic>? table,
    _i2.Insertable<dynamic>? insertable, {
    int? startIndex,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #$writeInsertable,
              [table, insertable],
              {#startIndex: startIndex},
            ),
            returnValue: _FakeGenerationContext_29(
              this,
              Invocation.method(
                #$writeInsertable,
                [table, insertable],
                {#startIndex: startIndex},
              ),
            ),
          )
          as _i2.GenerationContext);

  @override
  String $expandVar(int? start, int? amount) =>
      (super.noSuchMethod(
            Invocation.method(#$expandVar, [start, amount]),
            returnValue: _i10.dummyValue<String>(
              this,
              Invocation.method(#$expandVar, [start, amount]),
            ),
          )
          as String);
}

/// A class which mocks [TransactionDao].
///
/// See the documentation for Mockito's code generation for more information.
class MockTransactionDao extends _i1.Mock implements _i4.TransactionDao {
  MockTransactionDao() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.AppDatabase get attachedDatabase =>
      (super.noSuchMethod(
            Invocation.getter(#attachedDatabase),
            returnValue: _FakeAppDatabase_30(
              this,
              Invocation.getter(#attachedDatabase),
            ),
          )
          as _i7.AppDatabase);

  @override
  _i2.DatabaseConnection get connection =>
      (super.noSuchMethod(
            Invocation.getter(#connection),
            returnValue: _FakeDatabaseConnection_16(
              this,
              Invocation.getter(#connection),
            ),
          )
          as _i2.DatabaseConnection);

  @override
  _i2.DriftDatabaseOptions get options =>
      (super.noSuchMethod(
            Invocation.getter(#options),
            returnValue: _FakeDriftDatabaseOptions_14(
              this,
              Invocation.getter(#options),
            ),
          )
          as _i2.DriftDatabaseOptions);

  @override
  _i2.SqlTypes get typeMapping =>
      (super.noSuchMethod(
            Invocation.getter(#typeMapping),
            returnValue: _i10.dummyValue<_i2.SqlTypes>(
              this,
              Invocation.getter(#typeMapping),
            ),
          )
          as _i2.SqlTypes);

  @override
  _i2.QueryExecutor get executor =>
      (super.noSuchMethod(
            Invocation.getter(#executor),
            returnValue: _FakeQueryExecutor_17(
              this,
              Invocation.getter(#executor),
            ),
          )
          as _i2.QueryExecutor);

  @override
  _i8.StreamQueryStore get streamQueries =>
      (super.noSuchMethod(
            Invocation.getter(#streamQueries),
            returnValue: _FakeStreamQueryStore_18(
              this,
              Invocation.getter(#streamQueries),
            ),
          )
          as _i8.StreamQueryStore);

  @override
  _i2.DatabaseConnectionUser get resolvedEngine =>
      (super.noSuchMethod(
            Invocation.getter(#resolvedEngine),
            returnValue: _FakeDatabaseConnectionUser_19(
              this,
              Invocation.getter(#resolvedEngine),
            ),
          )
          as _i2.DatabaseConnectionUser);

  @override
  _i7.$TransactionsTable get transactions =>
      (super.noSuchMethod(
            Invocation.getter(#transactions),
            returnValue: _Fake$TransactionsTable_8(
              this,
              Invocation.getter(#transactions),
            ),
          )
          as _i7.$TransactionsTable);

  @override
  _i7.$CategoriesTable get categories =>
      (super.noSuchMethod(
            Invocation.getter(#categories),
            returnValue: _Fake$CategoriesTable_6(
              this,
              Invocation.getter(#categories),
            ),
          )
          as _i7.$CategoriesTable);

  @override
  _i7.$TransactionCategoryMapTable get transactionCategoryMap =>
      (super.noSuchMethod(
            Invocation.getter(#transactionCategoryMap),
            returnValue: _Fake$TransactionCategoryMapTable_9(
              this,
              Invocation.getter(#transactionCategoryMap),
            ),
          )
          as _i7.$TransactionCategoryMapTable);

  @override
  _i4.TransactionDaoManager get managers =>
      (super.noSuchMethod(
            Invocation.getter(#managers),
            returnValue: _FakeTransactionDaoManager_31(
              this,
              Invocation.getter(#managers),
            ),
          )
          as _i4.TransactionDaoManager);

  @override
  _i9.Future<_i7.Transaction> insertTransaction({
    required _i11.Decimal? amount,
    required _i12.TransactionType? type,
    required String? shortDescription,
    String? longDescription,
    required DateTime? transactionDate,
    required _i12.TransactionSource? source,
    String? currency = 'ZAR',
  }) =>
      (super.noSuchMethod(
            Invocation.method(#insertTransaction, [], {
              #amount: amount,
              #type: type,
              #shortDescription: shortDescription,
              #longDescription: longDescription,
              #transactionDate: transactionDate,
              #source: source,
              #currency: currency,
            }),
            returnValue: _i9.Future<_i7.Transaction>.value(
              _FakeTransaction_32(
                this,
                Invocation.method(#insertTransaction, [], {
                  #amount: amount,
                  #type: type,
                  #shortDescription: shortDescription,
                  #longDescription: longDescription,
                  #transactionDate: transactionDate,
                  #source: source,
                  #currency: currency,
                }),
              ),
            ),
          )
          as _i9.Future<_i7.Transaction>);

  @override
  _i9.Future<_i7.Transaction?> getTransactionById(
    String? id, {
    bool? includeDeleted = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #getTransactionById,
              [id],
              {#includeDeleted: includeDeleted},
            ),
            returnValue: _i9.Future<_i7.Transaction?>.value(),
          )
          as _i9.Future<_i7.Transaction?>);

  @override
  _i9.Future<List<_i7.Transaction>> getAllTransactions({
    bool? includeDeleted = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#getAllTransactions, [], {
              #includeDeleted: includeDeleted,
            }),
            returnValue: _i9.Future<List<_i7.Transaction>>.value(
              <_i7.Transaction>[],
            ),
          )
          as _i9.Future<List<_i7.Transaction>>);

  @override
  _i9.Future<List<_i7.Transaction>> getTransactionsByType(
    _i12.TransactionType? type, {
    bool? includeDeleted = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #getTransactionsByType,
              [type],
              {#includeDeleted: includeDeleted},
            ),
            returnValue: _i9.Future<List<_i7.Transaction>>.value(
              <_i7.Transaction>[],
            ),
          )
          as _i9.Future<List<_i7.Transaction>>);

  @override
  _i9.Future<List<_i7.Transaction>> getTransactionsByDateRange(
    DateTime? start,
    DateTime? end, {
    bool? includeDeleted = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #getTransactionsByDateRange,
              [start, end],
              {#includeDeleted: includeDeleted},
            ),
            returnValue: _i9.Future<List<_i7.Transaction>>.value(
              <_i7.Transaction>[],
            ),
          )
          as _i9.Future<List<_i7.Transaction>>);

  @override
  _i9.Future<_i7.Transaction> updateTransaction(
    String? id, {
    _i11.Decimal? amount,
    _i12.TransactionType? type,
    String? shortDescription,
    _i2.Value<String?>? longDescription = const _i2.Value.absent(),
    DateTime? transactionDate,
    _i12.TransactionSource? source,
    String? currency,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #updateTransaction,
              [id],
              {
                #amount: amount,
                #type: type,
                #shortDescription: shortDescription,
                #longDescription: longDescription,
                #transactionDate: transactionDate,
                #source: source,
                #currency: currency,
              },
            ),
            returnValue: _i9.Future<_i7.Transaction>.value(
              _FakeTransaction_32(
                this,
                Invocation.method(
                  #updateTransaction,
                  [id],
                  {
                    #amount: amount,
                    #type: type,
                    #shortDescription: shortDescription,
                    #longDescription: longDescription,
                    #transactionDate: transactionDate,
                    #source: source,
                    #currency: currency,
                  },
                ),
              ),
            ),
          )
          as _i9.Future<_i7.Transaction>);

  @override
  _i9.Future<void> softDeleteTransaction(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#softDeleteTransaction, [id]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<void> hardDeleteTransaction(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#hardDeleteTransaction, [id]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<void> restoreTransaction(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#restoreTransaction, [id]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<_i7.TransactionCategoryMapData> assignCategory({
    required String? transactionId,
    required String? categoryId,
    required _i12.AssignmentSource? assignmentSource,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#assignCategory, [], {
              #transactionId: transactionId,
              #categoryId: categoryId,
              #assignmentSource: assignmentSource,
            }),
            returnValue: _i9.Future<_i7.TransactionCategoryMapData>.value(
              _FakeTransactionCategoryMapData_33(
                this,
                Invocation.method(#assignCategory, [], {
                  #transactionId: transactionId,
                  #categoryId: categoryId,
                  #assignmentSource: assignmentSource,
                }),
              ),
            ),
          )
          as _i9.Future<_i7.TransactionCategoryMapData>);

  @override
  _i9.Future<_i7.TransactionCategoryMapData?> getCategoryForTransaction(
    String? transactionId,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getCategoryForTransaction, [transactionId]),
            returnValue: _i9.Future<_i7.TransactionCategoryMapData?>.value(),
          )
          as _i9.Future<_i7.TransactionCategoryMapData?>);

  @override
  _i9.Future<List<_i7.TransactionCategoryMapData>> getTransactionsForCategory(
    String? categoryId,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getTransactionsForCategory, [categoryId]),
            returnValue: _i9.Future<List<_i7.TransactionCategoryMapData>>.value(
              <_i7.TransactionCategoryMapData>[],
            ),
          )
          as _i9.Future<List<_i7.TransactionCategoryMapData>>);

  @override
  _i9.Future<void> removeMapping(String? transactionId) =>
      (super.noSuchMethod(
            Invocation.method(#removeMapping, [transactionId]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<List<_i7.Transaction>> getTransactionsByCategory(
    String? categoryId,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getTransactionsByCategory, [categoryId]),
            returnValue: _i9.Future<List<_i7.Transaction>>.value(
              <_i7.Transaction>[],
            ),
          )
          as _i9.Future<List<_i7.Transaction>>);

  @override
  _i9.Stream<T> createStream<T extends Object>(
    _i8.QueryStreamFetcher<T>? stmt,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#createStream, [stmt]),
            returnValue: _i9.Stream<T>.empty(),
          )
          as _i9.Stream<T>);

  @override
  T alias<T, D>(_i2.ResultSetImplementation<T, D>? table, String? alias) =>
      (super.noSuchMethod(
            Invocation.method(#alias, [table, alias]),
            returnValue: _i10.dummyValue<T>(
              this,
              Invocation.method(#alias, [table, alias]),
            ),
          )
          as T);

  @override
  void markTablesUpdated(Iterable<_i2.TableInfo<_i2.Table, dynamic>>? tables) =>
      super.noSuchMethod(
        Invocation.method(#markTablesUpdated, [tables]),
        returnValueForMissingStub: null,
      );

  @override
  void notifyUpdates(Set<_i2.TableUpdate>? updates) => super.noSuchMethod(
    Invocation.method(#notifyUpdates, [updates]),
    returnValueForMissingStub: null,
  );

  @override
  _i9.Stream<Set<_i2.TableUpdate>> tableUpdates([
    _i2.TableUpdateQuery? query = const _i2.TableUpdateQuery.any(),
  ]) =>
      (super.noSuchMethod(
            Invocation.method(#tableUpdates, [query]),
            returnValue: _i9.Stream<Set<_i2.TableUpdate>>.empty(),
          )
          as _i9.Stream<Set<_i2.TableUpdate>>);

  @override
  _i9.Future<T> doWhenOpened<T>(
    _i9.FutureOr<T> Function(_i2.QueryExecutor)? fn,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#doWhenOpened, [fn]),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(#doWhenOpened, [fn]),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(this, Invocation.method(#doWhenOpened, [fn])),
          )
          as _i9.Future<T>);

  @override
  _i2.InsertStatement<T, D> into<T extends _i2.Table, D>(
    _i2.TableInfo<T, D>? table,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#into, [table]),
            returnValue: _FakeInsertStatement_22<T, D>(
              this,
              Invocation.method(#into, [table]),
            ),
          )
          as _i2.InsertStatement<T, D>);

  @override
  _i2.UpdateStatement<Tbl, R> update<Tbl extends _i2.Table, R>(
    _i2.TableInfo<Tbl, R>? table,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#update, [table]),
            returnValue: _FakeUpdateStatement_23<Tbl, R>(
              this,
              Invocation.method(#update, [table]),
            ),
          )
          as _i2.UpdateStatement<Tbl, R>);

  @override
  _i2.SimpleSelectStatement<T, R> select<T extends _i2.HasResultSet, R>(
    _i2.ResultSetImplementation<T, R>? table, {
    bool? distinct = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#select, [table], {#distinct: distinct}),
            returnValue: _FakeSimpleSelectStatement_24<T, R>(
              this,
              Invocation.method(#select, [table], {#distinct: distinct}),
            ),
          )
          as _i2.SimpleSelectStatement<T, R>);

  @override
  _i2.JoinedSelectStatement<T, R> selectOnly<T extends _i2.HasResultSet, R>(
    _i2.ResultSetImplementation<T, R>? table, {
    bool? distinct = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#selectOnly, [table], {#distinct: distinct}),
            returnValue: _FakeJoinedSelectStatement_25<T, R>(
              this,
              Invocation.method(#selectOnly, [table], {#distinct: distinct}),
            ),
          )
          as _i2.JoinedSelectStatement<T, R>);

  @override
  _i2.BaseSelectStatement<_i2.TypedResult> selectExpressions(
    Iterable<_i2.Expression<Object>>? columns,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#selectExpressions, [columns]),
            returnValue: _FakeBaseSelectStatement_26<_i2.TypedResult>(
              this,
              Invocation.method(#selectExpressions, [columns]),
            ),
          )
          as _i2.BaseSelectStatement<_i2.TypedResult>);

  @override
  _i2.DeleteStatement<T, D> delete<T extends _i2.Table, D>(
    _i2.TableInfo<T, D>? table,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#delete, [table]),
            returnValue: _FakeDeleteStatement_27<T, D>(
              this,
              Invocation.method(#delete, [table]),
            ),
          )
          as _i2.DeleteStatement<T, D>);

  @override
  _i9.Future<int> customUpdate(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? updates,
    _i2.UpdateKind? updateKind,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customUpdate,
              [query],
              {
                #variables: variables,
                #updates: updates,
                #updateKind: updateKind,
              },
            ),
            returnValue: _i9.Future<int>.value(0),
          )
          as _i9.Future<int>);

  @override
  _i9.Future<int> customInsert(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? updates,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customInsert,
              [query],
              {#variables: variables, #updates: updates},
            ),
            returnValue: _i9.Future<int>.value(0),
          )
          as _i9.Future<int>);

  @override
  _i9.Future<List<_i2.QueryRow>> customWriteReturning(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? updates,
    _i2.UpdateKind? updateKind,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customWriteReturning,
              [query],
              {
                #variables: variables,
                #updates: updates,
                #updateKind: updateKind,
              },
            ),
            returnValue: _i9.Future<List<_i2.QueryRow>>.value(<_i2.QueryRow>[]),
          )
          as _i9.Future<List<_i2.QueryRow>>);

  @override
  _i2.Selectable<_i2.QueryRow> customSelect(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? readsFrom = const {},
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customSelect,
              [query],
              {#variables: variables, #readsFrom: readsFrom},
            ),
            returnValue: _FakeSelectable_28<_i2.QueryRow>(
              this,
              Invocation.method(
                #customSelect,
                [query],
                {#variables: variables, #readsFrom: readsFrom},
              ),
            ),
          )
          as _i2.Selectable<_i2.QueryRow>);

  @override
  _i2.Selectable<_i2.QueryRow> customSelectQuery(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? readsFrom = const {},
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customSelectQuery,
              [query],
              {#variables: variables, #readsFrom: readsFrom},
            ),
            returnValue: _FakeSelectable_28<_i2.QueryRow>(
              this,
              Invocation.method(
                #customSelectQuery,
                [query],
                {#variables: variables, #readsFrom: readsFrom},
              ),
            ),
          )
          as _i2.Selectable<_i2.QueryRow>);

  @override
  _i9.Future<void> customStatement(String? statement, [List<dynamic>? args]) =>
      (super.noSuchMethod(
            Invocation.method(#customStatement, [statement, args]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<T> transaction<T>(
    _i9.Future<T> Function()? action, {
    bool? requireNew = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #transaction,
              [action],
              {#requireNew: requireNew},
            ),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(
                      #transaction,
                      [action],
                      {#requireNew: requireNew},
                    ),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(
                  this,
                  Invocation.method(
                    #transaction,
                    [action],
                    {#requireNew: requireNew},
                  ),
                ),
          )
          as _i9.Future<T>);

  @override
  _i9.Future<T> exclusively<T>(_i9.Future<T> Function()? action) =>
      (super.noSuchMethod(
            Invocation.method(#exclusively, [action]),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(#exclusively, [action]),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(
                  this,
                  Invocation.method(#exclusively, [action]),
                ),
          )
          as _i9.Future<T>);

  @override
  _i9.Future<void> batch(_i9.FutureOr<void> Function(_i2.Batch)? runInBatch) =>
      (super.noSuchMethod(
            Invocation.method(#batch, [runInBatch]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<T> runWithInterceptor<T>(
    _i9.Future<T> Function()? action, {
    required _i2.QueryInterceptor? interceptor,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #runWithInterceptor,
              [action],
              {#interceptor: interceptor},
            ),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(
                      #runWithInterceptor,
                      [action],
                      {#interceptor: interceptor},
                    ),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(
                  this,
                  Invocation.method(
                    #runWithInterceptor,
                    [action],
                    {#interceptor: interceptor},
                  ),
                ),
          )
          as _i9.Future<T>);

  @override
  _i2.GenerationContext $write(
    _i2.Component? component, {
    bool? hasMultipleTables,
    int? startIndex,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #$write,
              [component],
              {#hasMultipleTables: hasMultipleTables, #startIndex: startIndex},
            ),
            returnValue: _FakeGenerationContext_29(
              this,
              Invocation.method(
                #$write,
                [component],
                {
                  #hasMultipleTables: hasMultipleTables,
                  #startIndex: startIndex,
                },
              ),
            ),
          )
          as _i2.GenerationContext);

  @override
  _i2.GenerationContext $writeInsertable(
    _i2.TableInfo<_i2.Table, dynamic>? table,
    _i2.Insertable<dynamic>? insertable, {
    int? startIndex,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #$writeInsertable,
              [table, insertable],
              {#startIndex: startIndex},
            ),
            returnValue: _FakeGenerationContext_29(
              this,
              Invocation.method(
                #$writeInsertable,
                [table, insertable],
                {#startIndex: startIndex},
              ),
            ),
          )
          as _i2.GenerationContext);

  @override
  String $expandVar(int? start, int? amount) =>
      (super.noSuchMethod(
            Invocation.method(#$expandVar, [start, amount]),
            returnValue: _i10.dummyValue<String>(
              this,
              Invocation.method(#$expandVar, [start, amount]),
            ),
          )
          as String);

  @override
  _i9.Future<void> close() =>
      (super.noSuchMethod(
            Invocation.method(#close, []),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);
}

/// A class which mocks [CategoryDao].
///
/// See the documentation for Mockito's code generation for more information.
class MockCategoryDao extends _i1.Mock implements _i3.CategoryDao {
  MockCategoryDao() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.AppDatabase get attachedDatabase =>
      (super.noSuchMethod(
            Invocation.getter(#attachedDatabase),
            returnValue: _FakeAppDatabase_30(
              this,
              Invocation.getter(#attachedDatabase),
            ),
          )
          as _i7.AppDatabase);

  @override
  _i2.DatabaseConnection get connection =>
      (super.noSuchMethod(
            Invocation.getter(#connection),
            returnValue: _FakeDatabaseConnection_16(
              this,
              Invocation.getter(#connection),
            ),
          )
          as _i2.DatabaseConnection);

  @override
  _i2.DriftDatabaseOptions get options =>
      (super.noSuchMethod(
            Invocation.getter(#options),
            returnValue: _FakeDriftDatabaseOptions_14(
              this,
              Invocation.getter(#options),
            ),
          )
          as _i2.DriftDatabaseOptions);

  @override
  _i2.SqlTypes get typeMapping =>
      (super.noSuchMethod(
            Invocation.getter(#typeMapping),
            returnValue: _i10.dummyValue<_i2.SqlTypes>(
              this,
              Invocation.getter(#typeMapping),
            ),
          )
          as _i2.SqlTypes);

  @override
  _i2.QueryExecutor get executor =>
      (super.noSuchMethod(
            Invocation.getter(#executor),
            returnValue: _FakeQueryExecutor_17(
              this,
              Invocation.getter(#executor),
            ),
          )
          as _i2.QueryExecutor);

  @override
  _i8.StreamQueryStore get streamQueries =>
      (super.noSuchMethod(
            Invocation.getter(#streamQueries),
            returnValue: _FakeStreamQueryStore_18(
              this,
              Invocation.getter(#streamQueries),
            ),
          )
          as _i8.StreamQueryStore);

  @override
  _i2.DatabaseConnectionUser get resolvedEngine =>
      (super.noSuchMethod(
            Invocation.getter(#resolvedEngine),
            returnValue: _FakeDatabaseConnectionUser_19(
              this,
              Invocation.getter(#resolvedEngine),
            ),
          )
          as _i2.DatabaseConnectionUser);

  @override
  _i7.$CategoriesTable get categories =>
      (super.noSuchMethod(
            Invocation.getter(#categories),
            returnValue: _Fake$CategoriesTable_6(
              this,
              Invocation.getter(#categories),
            ),
          )
          as _i7.$CategoriesTable);

  @override
  _i7.$CategoryClosureTable get categoryClosure =>
      (super.noSuchMethod(
            Invocation.getter(#categoryClosure),
            returnValue: _Fake$CategoryClosureTable_7(
              this,
              Invocation.getter(#categoryClosure),
            ),
          )
          as _i7.$CategoryClosureTable);

  @override
  _i7.$TransactionsTable get transactions =>
      (super.noSuchMethod(
            Invocation.getter(#transactions),
            returnValue: _Fake$TransactionsTable_8(
              this,
              Invocation.getter(#transactions),
            ),
          )
          as _i7.$TransactionsTable);

  @override
  _i7.$TransactionCategoryMapTable get transactionCategoryMap =>
      (super.noSuchMethod(
            Invocation.getter(#transactionCategoryMap),
            returnValue: _Fake$TransactionCategoryMapTable_9(
              this,
              Invocation.getter(#transactionCategoryMap),
            ),
          )
          as _i7.$TransactionCategoryMapTable);

  @override
  _i7.$BudgetTemplatesTable get budgetTemplates =>
      (super.noSuchMethod(
            Invocation.getter(#budgetTemplates),
            returnValue: _Fake$BudgetTemplatesTable_10(
              this,
              Invocation.getter(#budgetTemplates),
            ),
          )
          as _i7.$BudgetTemplatesTable);

  @override
  _i7.$BudgetPeriodsTable get budgetPeriods =>
      (super.noSuchMethod(
            Invocation.getter(#budgetPeriods),
            returnValue: _Fake$BudgetPeriodsTable_11(
              this,
              Invocation.getter(#budgetPeriods),
            ),
          )
          as _i7.$BudgetPeriodsTable);

  @override
  _i3.CategoryDaoManager get managers =>
      (super.noSuchMethod(
            Invocation.getter(#managers),
            returnValue: _FakeCategoryDaoManager_34(
              this,
              Invocation.getter(#managers),
            ),
          )
          as _i3.CategoryDaoManager);

  @override
  _i9.Future<_i7.Category> insertCategory({
    required String? name,
    required _i12.CategoryType? type,
    _i13.IconData? icon,
    String? color,
    bool? isDefault = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#insertCategory, [], {
              #name: name,
              #type: type,
              #icon: icon,
              #color: color,
              #isDefault: isDefault,
            }),
            returnValue: _i9.Future<_i7.Category>.value(
              _FakeCategory_35(
                this,
                Invocation.method(#insertCategory, [], {
                  #name: name,
                  #type: type,
                  #icon: icon,
                  #color: color,
                  #isDefault: isDefault,
                }),
              ),
            ),
          )
          as _i9.Future<_i7.Category>);

  @override
  _i9.Future<_i7.Category?> getCategoryById(
    String? id, {
    bool? includeDeleted = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #getCategoryById,
              [id],
              {#includeDeleted: includeDeleted},
            ),
            returnValue: _i9.Future<_i7.Category?>.value(),
          )
          as _i9.Future<_i7.Category?>);

  @override
  _i9.Future<List<_i7.Category>> getAllCategories({
    bool? includeDeleted = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#getAllCategories, [], {
              #includeDeleted: includeDeleted,
            }),
            returnValue: _i9.Future<List<_i7.Category>>.value(<_i7.Category>[]),
          )
          as _i9.Future<List<_i7.Category>>);

  @override
  _i9.Future<List<_i7.Category>> getCategoriesByType(
    _i12.CategoryType? type, {
    bool? includeDeleted = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #getCategoriesByType,
              [type],
              {#includeDeleted: includeDeleted},
            ),
            returnValue: _i9.Future<List<_i7.Category>>.value(<_i7.Category>[]),
          )
          as _i9.Future<List<_i7.Category>>);

  @override
  _i9.Future<_i7.Category> updateCategory(
    String? id, {
    String? name,
    _i12.CategoryType? type,
    _i2.Value<_i13.IconData?>? icon = const _i2.Value.absent(),
    _i2.Value<String?>? color = const _i2.Value.absent(),
    bool? isDefault,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #updateCategory,
              [id],
              {
                #name: name,
                #type: type,
                #icon: icon,
                #color: color,
                #isDefault: isDefault,
              },
            ),
            returnValue: _i9.Future<_i7.Category>.value(
              _FakeCategory_35(
                this,
                Invocation.method(
                  #updateCategory,
                  [id],
                  {
                    #name: name,
                    #type: type,
                    #icon: icon,
                    #color: color,
                    #isDefault: isDefault,
                  },
                ),
              ),
            ),
          )
          as _i9.Future<_i7.Category>);

  @override
  _i9.Future<void> softDeleteCategory(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#softDeleteCategory, [id]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<void> hardDeleteCategory(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#hardDeleteCategory, [id]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<void> restoreCategory(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#restoreCategory, [id]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<List<_i7.Category>> getChildren(String? ancestorId) =>
      (super.noSuchMethod(
            Invocation.method(#getChildren, [ancestorId]),
            returnValue: _i9.Future<List<_i7.Category>>.value(<_i7.Category>[]),
          )
          as _i9.Future<List<_i7.Category>>);

  @override
  _i9.Future<List<_i7.Category>> getDescendants(String? ancestorId) =>
      (super.noSuchMethod(
            Invocation.method(#getDescendants, [ancestorId]),
            returnValue: _i9.Future<List<_i7.Category>>.value(<_i7.Category>[]),
          )
          as _i9.Future<List<_i7.Category>>);

  @override
  _i9.Future<void> moveCategory(String? categoryId, String? newParentId) =>
      (super.noSuchMethod(
            Invocation.method(#moveCategory, [categoryId, newParentId]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Stream<T> createStream<T extends Object>(
    _i8.QueryStreamFetcher<T>? stmt,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#createStream, [stmt]),
            returnValue: _i9.Stream<T>.empty(),
          )
          as _i9.Stream<T>);

  @override
  T alias<T, D>(_i2.ResultSetImplementation<T, D>? table, String? alias) =>
      (super.noSuchMethod(
            Invocation.method(#alias, [table, alias]),
            returnValue: _i10.dummyValue<T>(
              this,
              Invocation.method(#alias, [table, alias]),
            ),
          )
          as T);

  @override
  void markTablesUpdated(Iterable<_i2.TableInfo<_i2.Table, dynamic>>? tables) =>
      super.noSuchMethod(
        Invocation.method(#markTablesUpdated, [tables]),
        returnValueForMissingStub: null,
      );

  @override
  void notifyUpdates(Set<_i2.TableUpdate>? updates) => super.noSuchMethod(
    Invocation.method(#notifyUpdates, [updates]),
    returnValueForMissingStub: null,
  );

  @override
  _i9.Stream<Set<_i2.TableUpdate>> tableUpdates([
    _i2.TableUpdateQuery? query = const _i2.TableUpdateQuery.any(),
  ]) =>
      (super.noSuchMethod(
            Invocation.method(#tableUpdates, [query]),
            returnValue: _i9.Stream<Set<_i2.TableUpdate>>.empty(),
          )
          as _i9.Stream<Set<_i2.TableUpdate>>);

  @override
  _i9.Future<T> doWhenOpened<T>(
    _i9.FutureOr<T> Function(_i2.QueryExecutor)? fn,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#doWhenOpened, [fn]),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(#doWhenOpened, [fn]),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(this, Invocation.method(#doWhenOpened, [fn])),
          )
          as _i9.Future<T>);

  @override
  _i2.InsertStatement<T, D> into<T extends _i2.Table, D>(
    _i2.TableInfo<T, D>? table,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#into, [table]),
            returnValue: _FakeInsertStatement_22<T, D>(
              this,
              Invocation.method(#into, [table]),
            ),
          )
          as _i2.InsertStatement<T, D>);

  @override
  _i2.UpdateStatement<Tbl, R> update<Tbl extends _i2.Table, R>(
    _i2.TableInfo<Tbl, R>? table,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#update, [table]),
            returnValue: _FakeUpdateStatement_23<Tbl, R>(
              this,
              Invocation.method(#update, [table]),
            ),
          )
          as _i2.UpdateStatement<Tbl, R>);

  @override
  _i2.SimpleSelectStatement<T, R> select<T extends _i2.HasResultSet, R>(
    _i2.ResultSetImplementation<T, R>? table, {
    bool? distinct = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#select, [table], {#distinct: distinct}),
            returnValue: _FakeSimpleSelectStatement_24<T, R>(
              this,
              Invocation.method(#select, [table], {#distinct: distinct}),
            ),
          )
          as _i2.SimpleSelectStatement<T, R>);

  @override
  _i2.JoinedSelectStatement<T, R> selectOnly<T extends _i2.HasResultSet, R>(
    _i2.ResultSetImplementation<T, R>? table, {
    bool? distinct = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#selectOnly, [table], {#distinct: distinct}),
            returnValue: _FakeJoinedSelectStatement_25<T, R>(
              this,
              Invocation.method(#selectOnly, [table], {#distinct: distinct}),
            ),
          )
          as _i2.JoinedSelectStatement<T, R>);

  @override
  _i2.BaseSelectStatement<_i2.TypedResult> selectExpressions(
    Iterable<_i2.Expression<Object>>? columns,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#selectExpressions, [columns]),
            returnValue: _FakeBaseSelectStatement_26<_i2.TypedResult>(
              this,
              Invocation.method(#selectExpressions, [columns]),
            ),
          )
          as _i2.BaseSelectStatement<_i2.TypedResult>);

  @override
  _i2.DeleteStatement<T, D> delete<T extends _i2.Table, D>(
    _i2.TableInfo<T, D>? table,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#delete, [table]),
            returnValue: _FakeDeleteStatement_27<T, D>(
              this,
              Invocation.method(#delete, [table]),
            ),
          )
          as _i2.DeleteStatement<T, D>);

  @override
  _i9.Future<int> customUpdate(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? updates,
    _i2.UpdateKind? updateKind,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customUpdate,
              [query],
              {
                #variables: variables,
                #updates: updates,
                #updateKind: updateKind,
              },
            ),
            returnValue: _i9.Future<int>.value(0),
          )
          as _i9.Future<int>);

  @override
  _i9.Future<int> customInsert(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? updates,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customInsert,
              [query],
              {#variables: variables, #updates: updates},
            ),
            returnValue: _i9.Future<int>.value(0),
          )
          as _i9.Future<int>);

  @override
  _i9.Future<List<_i2.QueryRow>> customWriteReturning(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? updates,
    _i2.UpdateKind? updateKind,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customWriteReturning,
              [query],
              {
                #variables: variables,
                #updates: updates,
                #updateKind: updateKind,
              },
            ),
            returnValue: _i9.Future<List<_i2.QueryRow>>.value(<_i2.QueryRow>[]),
          )
          as _i9.Future<List<_i2.QueryRow>>);

  @override
  _i2.Selectable<_i2.QueryRow> customSelect(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? readsFrom = const {},
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customSelect,
              [query],
              {#variables: variables, #readsFrom: readsFrom},
            ),
            returnValue: _FakeSelectable_28<_i2.QueryRow>(
              this,
              Invocation.method(
                #customSelect,
                [query],
                {#variables: variables, #readsFrom: readsFrom},
              ),
            ),
          )
          as _i2.Selectable<_i2.QueryRow>);

  @override
  _i2.Selectable<_i2.QueryRow> customSelectQuery(
    String? query, {
    List<_i2.Variable<Object>>? variables = const [],
    Set<_i2.ResultSetImplementation<dynamic, dynamic>>? readsFrom = const {},
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #customSelectQuery,
              [query],
              {#variables: variables, #readsFrom: readsFrom},
            ),
            returnValue: _FakeSelectable_28<_i2.QueryRow>(
              this,
              Invocation.method(
                #customSelectQuery,
                [query],
                {#variables: variables, #readsFrom: readsFrom},
              ),
            ),
          )
          as _i2.Selectable<_i2.QueryRow>);

  @override
  _i9.Future<void> customStatement(String? statement, [List<dynamic>? args]) =>
      (super.noSuchMethod(
            Invocation.method(#customStatement, [statement, args]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<T> transaction<T>(
    _i9.Future<T> Function()? action, {
    bool? requireNew = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #transaction,
              [action],
              {#requireNew: requireNew},
            ),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(
                      #transaction,
                      [action],
                      {#requireNew: requireNew},
                    ),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(
                  this,
                  Invocation.method(
                    #transaction,
                    [action],
                    {#requireNew: requireNew},
                  ),
                ),
          )
          as _i9.Future<T>);

  @override
  _i9.Future<T> exclusively<T>(_i9.Future<T> Function()? action) =>
      (super.noSuchMethod(
            Invocation.method(#exclusively, [action]),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(#exclusively, [action]),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(
                  this,
                  Invocation.method(#exclusively, [action]),
                ),
          )
          as _i9.Future<T>);

  @override
  _i9.Future<void> batch(_i9.FutureOr<void> Function(_i2.Batch)? runInBatch) =>
      (super.noSuchMethod(
            Invocation.method(#batch, [runInBatch]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);

  @override
  _i9.Future<T> runWithInterceptor<T>(
    _i9.Future<T> Function()? action, {
    required _i2.QueryInterceptor? interceptor,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #runWithInterceptor,
              [action],
              {#interceptor: interceptor},
            ),
            returnValue:
                _i10.ifNotNull(
                  _i10.dummyValueOrNull<T>(
                    this,
                    Invocation.method(
                      #runWithInterceptor,
                      [action],
                      {#interceptor: interceptor},
                    ),
                  ),
                  (T v) => _i9.Future<T>.value(v),
                ) ??
                _FakeFuture_21<T>(
                  this,
                  Invocation.method(
                    #runWithInterceptor,
                    [action],
                    {#interceptor: interceptor},
                  ),
                ),
          )
          as _i9.Future<T>);

  @override
  _i2.GenerationContext $write(
    _i2.Component? component, {
    bool? hasMultipleTables,
    int? startIndex,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #$write,
              [component],
              {#hasMultipleTables: hasMultipleTables, #startIndex: startIndex},
            ),
            returnValue: _FakeGenerationContext_29(
              this,
              Invocation.method(
                #$write,
                [component],
                {
                  #hasMultipleTables: hasMultipleTables,
                  #startIndex: startIndex,
                },
              ),
            ),
          )
          as _i2.GenerationContext);

  @override
  _i2.GenerationContext $writeInsertable(
    _i2.TableInfo<_i2.Table, dynamic>? table,
    _i2.Insertable<dynamic>? insertable, {
    int? startIndex,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #$writeInsertable,
              [table, insertable],
              {#startIndex: startIndex},
            ),
            returnValue: _FakeGenerationContext_29(
              this,
              Invocation.method(
                #$writeInsertable,
                [table, insertable],
                {#startIndex: startIndex},
              ),
            ),
          )
          as _i2.GenerationContext);

  @override
  String $expandVar(int? start, int? amount) =>
      (super.noSuchMethod(
            Invocation.method(#$expandVar, [start, amount]),
            returnValue: _i10.dummyValue<String>(
              this,
              Invocation.method(#$expandVar, [start, amount]),
            ),
          )
          as String);

  @override
  _i9.Future<void> close() =>
      (super.noSuchMethod(
            Invocation.method(#close, []),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);
}
