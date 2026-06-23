import 'package:mockito/annotations.dart';
import 'package:budgetit/database/daos/budget_dao.dart';
import 'package:budgetit/database/daos/category_dao.dart';
import 'package:budgetit/database/daos/settings_dao.dart';
import 'package:budgetit/database/daos/transaction_dao.dart';
import 'package:budgetit/database/app_database.dart';

@GenerateNiceMocks([
  MockSpec<CategoryDao>(),
  MockSpec<TransactionDao>(),
  MockSpec<BudgetDao>(),
  MockSpec<SettingsDao>(),
  MockSpec<AppDatabase>(),
])
void generateMocks() {}
