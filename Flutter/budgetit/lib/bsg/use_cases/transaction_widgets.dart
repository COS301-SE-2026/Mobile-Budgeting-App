import 'package:budgetit/bsg/preview_support.dart';
import 'package:budgetit/shared/widgets/search_bar.dart' as legacy;
import 'package:budgetit/shared/widgets/spending_chart.dart';
import 'package:budgetit/shared/widgets/transaction_filter_bar.dart';
import 'package:budgetit/shared/widgets/transaction_tile.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

Widget _canvas(
  BuildContext context,
  Widget child, {
  bool framed = true,
}) {
  final colours = context.colours;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Scaffold(
    backgroundColor: colours.background,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: framed
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? colours.blendedprimary
                        : colours.secondary,
                    border: Border.all(
                      color: Colors.black,
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(6, 6),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: child,
                )
              : child,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Transaction Tile',
  type: TransactionTile,
  path: '[Widgets]',
)
Widget transactionTileUseCase(BuildContext context) {
  return appPreview(
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
}

@widgetbook.UseCase(
  name: 'Transaction Filter Bar',
  type: TransactionFilterBar,
  path: '[Widgets]',
)
Widget transactionFilterBarUseCase(BuildContext context) {
  return _canvas(
    context,
    TransactionFilterBar(
      categories: const [
        'Groceries',
        'Dining',
        'Transport',
      ],
      categoryIcons: const {
        'Groceries': Icons.shopping_cart_outlined,
        'Dining': Icons.restaurant_outlined,
        'Transport': Icons.directions_car_outlined,
      },
      selectedCategory: TransactionFilterBar.allCategories,
      selectedSort: TransactionSort.newest,
      onSearchChanged: (_) {},
      onCategoryChanged: (_) {},
      onSortChanged: (_) {},
    ),
  );
}



