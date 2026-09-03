import 'package:budgetit/bsg/preview_support.dart';
import 'package:budgetit/shared/widgets/bill_item.dart';
import 'package:budgetit/shared/widgets/box_popup_menu.dart';
import 'package:budgetit/shared/widgets/search_bar.dart' as legacy;
import 'package:budgetit/shared/widgets/spending_chart.dart';
import 'package:budgetit/shared/widgets/transaction_filter_bar.dart';
import 'package:budgetit/shared/widgets/transaction_tile.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

Widget _canvas(BuildContext context, Widget child) => Scaffold(
  backgroundColor: context.colours.background,
  body: Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: child,
      ),
    ),
  ),
);

@widgetbook.UseCase(
  name: 'Transaction Tile',
  type: TransactionTile,
  path: '[Widgets]',
)
Widget transactionTileUseCase(BuildContext context) => appPreview(
  child: _canvas(
    context,
    const TransactionTile(
      icon: Icons.shopping_cart_outlined,
      title: 'Weekly groceries',
      subtitle: 'Groceries · 2 Sep 2026',
      amount: '-R485.59',
      isExpense: true,
    ),
  ),
);

@widgetbook.UseCase(
  name: 'Transaction Filter Bar',
  type: TransactionFilterBar,
  path: '[Widgets]',
)
Widget transactionFilterBarUseCase(BuildContext context) => _canvas(
  context,
  TransactionFilterBar(
    categories: const ['Groceries', 'Dining', 'Transport'],
    categoryIcons: const {'Groceries': Icons.shopping_cart_outlined},
    selectedCategory: TransactionFilterBar.allCategories,
    selectedSort: TransactionSort.newest,
    onSearchChanged: (_) {},
    onCategoryChanged: (_) {},
    onSortChanged: (_) {},
  ),
);

@widgetbook.UseCase(
  name: 'Spending Chart',
  type: SpendingChart,
  path: '[Widgets]',
)
Widget spendingChartUseCase(BuildContext context) => _canvas(
  context,
  SpendingChart(
    total: 'R4 200',
    categories: [
      SpendingCategory(
        label: 'Groceries',
        percentage: 45,
        color: context.colours.secondary,
      ),
      SpendingCategory(
        label: 'Transport',
        percentage: 30,
        color: context.colours.informational,
      ),
      SpendingCategory(
        label: 'Dining',
        percentage: 25,
        color: context.colours.greenAccents,
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'Bill Item', type: BillItem, path: '[Widgets]')
Widget billItemUseCase(BuildContext context) => _canvas(
  context,
  const BillItem(
    icon: Icons.bolt_outlined,
    title: 'Electricity',
    subtitle: 'Due 15 September',
    amount: 'R850',
  ),
);

@widgetbook.UseCase(
  name: 'Search Bar (Legacy)',
  type: legacy.SearchBar,
  path: '[Widgets]',
)
Widget searchBarUseCase(BuildContext context) =>
    _canvas(context, const legacy.SearchBar());

@widgetbook.UseCase(
  name: 'Transaction Menu',
  type: BoxPopupMenu,
  path: '[Widgets]',
)
Widget boxPopupMenuUseCase(BuildContext context) => _canvas(
  context,
  Container(
    color: context.colours.secondary,
    child: BoxPopupMenu(onSelected: (_) {}),
  ),
);
