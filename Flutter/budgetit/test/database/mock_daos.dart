// Mockito mock generation for the DAO layer.
//
// Run `dart run build_runner build` to regenerate mock_daos.mocks.dart.
// Import mock_daos.mocks.dart in widget/integration tests that need to
// stub DAO behaviour without a real database.

import 'package:mockito/annotations.dart';
import 'package:budgetit/database/daos/budget_dao.dart';
import 'package:budgetit/database/daos/category_dao.dart';
import 'package:budgetit/database/daos/settings_dao.dart';
import 'package:budgetit/database/daos/transaction_dao.dart';

@GenerateNiceMocks([
  MockSpec<CategoryDao>(),
  MockSpec<TransactionDao>(),
  MockSpec<BudgetDao>(),
  MockSpec<SettingsDao>(),
])
// Annotation target only — build_runner reads @GenerateNiceMocks and writes mock_daos.mocks.dart.
void generateMocks() {}
