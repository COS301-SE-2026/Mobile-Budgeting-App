import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Date Picker',
  type: BudgetDatePickerPreview,
  path: '[Widgets]',
)
Widget datePickerUseCase(BuildContext context) {
  return const BudgetDatePickerPreview();
}

/// Interactive preview of the branded calendar used by transaction dialogs.
class BudgetDatePickerPreview extends StatefulWidget {
  const BudgetDatePickerPreview({super.key});

  @override
  State<BudgetDatePickerPreview> createState() =>
      _BudgetDatePickerPreviewState();
}

class _BudgetDatePickerPreviewState extends State<BudgetDatePickerPreview> {
  DateTime _selectedDate = DateTime(2026, 9, 3);

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary : colours.secondary;
    final cardTextColor = isDark ? colours.secondary : colours.background;

    return Scaffold(
      backgroundColor: colours.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 430),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(6, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SELECT TRANSACTION DATE',
                  style: colours.h2.copyWith(color: cardTextColor),
                ),
                const SizedBox(height: 12),
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: cardTextColor,
                      primary: cardTextColor,
                      onPrimary: cardColor,
                      surface: cardColor,
                      onSurface: cardTextColor,
                      brightness: Theme.of(context).brightness,
                    ),
                    datePickerTheme: DatePickerThemeData(
                      backgroundColor: cardColor,
                      headerBackgroundColor: cardColor,
                      headerForegroundColor: cardTextColor,
                      weekdayStyle: colours.b5.copyWith(
                        color: cardTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                      dayStyle: colours.b1.copyWith(color: cardTextColor),
                      yearStyle: colours.b1.copyWith(color: cardTextColor),
                      dayShape: WidgetStateProperty.resolveWith((states) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: states.contains(WidgetState.selected)
                              ? const BorderSide(color: Colors.black, width: 2)
                              : BorderSide.none,
                        );
                      }),
                      todayBorder: BorderSide(color: cardTextColor, width: 2),
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2035, 12, 31),
                    onDateChanged: (date) =>
                        setState(() => _selectedDate = date),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Selected: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: colours.b1.copyWith(color: cardTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
