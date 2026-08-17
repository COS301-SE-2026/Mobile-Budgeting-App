import 'package:budgetit/shared/widgets/help_menu_page.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

//test wrapper, creates mini app environment to render help menu, so every test wont need to repeat setup
Widget wrapHelpMenu() {
  return ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: MaterialApp(
      theme: ThemeData(
        extensions: [MyColours.lightTheme],
      ),
      home: const HelpMenuPage(),
    ),
  );
}

void main() {
  group('HelpMenuPage', () {
    testWidgets('renders the help menu heading and intro text', (tester) async {
      await tester.pumpWidget(wrapHelpMenu());

      expect(find.text('Help Menu'), findsOneWidget);
      expect(find.text('HELP MENU'), findsOneWidget);
      expect(find.text('Need a hand?'), findsOneWidget);
      expect(find.text('QUICK HELP'), findsOneWidget);
    });

    testWidgets('shows all help dropdown titles', (tester) async {
      //building and displaying help menu screen inside this test:
      await tester.pumpWidget(wrapHelpMenu());
      // tester will load widgets/etc
      expect(find.text('HOW TO ADD NEW TRANSACTION'), findsOneWidget);
      expect(find.text('HOW TO ADD TRANSACTION TO A BUDGET'), findsOneWidget);
      expect(find.text('HOW TO VIEW GRAPHICAL REPORTS'), findsOneWidget);
    });

    testWidgets('expands add transaction help steps', (tester) async {
      await tester.pumpWidget(wrapHelpMenu());
      //pump widget puts a widget on fake test screen
      await tester.tap(find.text('HOW TO ADD NEW TRANSACTION'));
      await tester.pumpAndSettle();

      expect(
        find.text('Go to the Transaction Manager page using the money icon in the bottom navigation.'),
        findsOneWidget,
      );
      expect(
        find.text('Tap the plus button at the bottom of the screen.'),
        findsOneWidget,
      );
      expect(
        find.text('Tap Add to save the transaction.'),
        findsOneWidget,
      );
    });

    testWidgets('help page is scrollable', (tester) async {
      await tester.pumpWidget(wrapHelpMenu());

      expect(find.byType(SingleChildScrollView), findsOneWidget);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}