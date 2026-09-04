import 'package:budgetit/shared/widgets/searchbox.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

enum TransactionSort { newest, oldest, amountHigh, amountLow, nameAZ }

class TransactionFilterBar extends StatelessWidget {
  const TransactionFilterBar({
    super.key,
    required this.categories,
    this.categoryIcons = const {},
    required this.selectedCategory,
    required this.selectedSort,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onSortChanged,
  });

  static const allCategories = 'All categories';

  final List<String> categories;
  final Map<String, IconData> categoryIcons;
  final String selectedCategory;
  final TransactionSort selectedSort;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<TransactionSort> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dropdowns = Row(
          children: [
            Expanded(
              child: _FilterDropdown<String>(
                value: selectedCategory,
                isActive: selectedCategory != allCategories,
                icon: Icons.category_outlined,
                iconFor: (value) => value == allCategories
                    ? Icons.category_outlined
                    : categoryIcons[value] ?? Icons.category_outlined,
                items: [allCategories, ...categories],
                labelFor: (value) => value,
                onChanged: onCategoryChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FilterDropdown<TransactionSort>(
                value: selectedSort,
                isActive: selectedSort != TransactionSort.newest,
                icon: Icons.sort,
                items: TransactionSort.values,
                labelFor: _sortLabel,
                onChanged: onSortChanged,
              ),
            ),
          ],
        );

        if (constraints.maxWidth < 620) {
          return Column(
            children: [
              SearchBox(
                hintText: 'Search transactions',
                onChanged: onSearchChanged,
              ),
              const SizedBox(height: 10),
              dropdowns,
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              flex: 2,
              child: SearchBox(
                hintText: 'Search transactions',
                onChanged: onSearchChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(flex: 3, child: dropdowns),
          ],
        );
      },
    );
  }

  static String _sortLabel(TransactionSort sort) => switch (sort) {
    TransactionSort.newest => 'Newest first',
    TransactionSort.oldest => 'Oldest first',
    TransactionSort.amountHigh => 'Amount: high',
    TransactionSort.amountLow => 'Amount: low',
    TransactionSort.nameAZ => 'Name: A–Z',
  };
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.isActive,
    required this.icon,
    this.iconFor,
    required this.items,
    required this.labelFor,
    required this.onChanged,
  });

  final T value;
  final bool isActive;
  final IconData icon;
  final IconData Function(T)? iconFor;
  final List<T> items;
  final String Function(T) labelFor;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isActive
            ? context.colours.informational
            : context.colours.searchBar,
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: context.colours.searchBar,
          iconEnabledColor: context.colours.cardText,
          style: context.colours.b1.copyWith(color: context.colours.cardText),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(
                        iconFor?.call(item) ?? icon,
                        size: 18,
                        color: context.colours.cardText,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          labelFor(item),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}
