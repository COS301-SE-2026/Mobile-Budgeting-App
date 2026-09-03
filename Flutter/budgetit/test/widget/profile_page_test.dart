import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrapProfilePage({Brightness brightness = Brightness.dark}) {
  final colours = brightness == Brightness.dark
      ? MyColours.darkTheme
      : MyColours.lightTheme;

  return MaterialApp(
    theme: ThemeData(
      brightness: brightness,
      extensions: <ThemeExtension<dynamic>>[colours],
    ),
    home: const ProfilePage(),
  );
}

void main() {
  group('ProfilePage', () {
    testWidgets('renders profile header and account details', (tester) async {
      await tester.pumpWidget(_wrapProfilePage());

      expect(find.text('Budget.IT'), findsOneWidget);
      expect(find.text('Alex Smith'), findsOneWidget);
      expect(find.text('alex.smith@example.com'), findsOneWidget);
      expect(find.text('PRO MEMBER'), findsOneWidget);
    });

    testWidgets('renders preferences section', (tester) async {
      await tester.pumpWidget(_wrapProfilePage());

      expect(find.text('PREFERENCES'), findsOneWidget);
      expect(find.text('Currency'), findsOneWidget);
      expect(find.text('USD (\$)'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Dark Mode (Enabled)'), findsOneWidget);
      expect(find.text('Bill Alerts'), findsOneWidget);
      expect(find.text('Daily Summaries'), findsOneWidget);
    });

    testWidgets('renders security section', (tester) async {
      await tester.pumpWidget(_wrapProfilePage());

      expect(find.text('SECURITY'), findsOneWidget);
      expect(find.text('Biometric Unlock'), findsOneWidget);
      expect(find.text('2-Factor Auth'), findsOneWidget);
    });

    testWidgets('renders logout button and version text', (tester) async {
      await tester.pumpWidget(_wrapProfilePage());

      expect(find.text('LOGOUT'), findsOneWidget);
      expect(
        find.text('VERSION 4.2.0-STABLE  •  MADE BY BUDGET.IT'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('renders in light theme without crashing', (tester) async {
      await tester.pumpWidget(_wrapProfilePage(brightness: Brightness.light));

      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.text('Alex Smith'), findsOneWidget);
      expect(find.text('PREFERENCES'), findsOneWidget);
      expect(find.text('SECURITY'), findsOneWidget);
    });
  });
}
