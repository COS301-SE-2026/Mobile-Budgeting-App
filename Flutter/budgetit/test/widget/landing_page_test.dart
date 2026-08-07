import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/shared/widgets/landingpage/landing_page.dart';
import 'package:budgetit/shared/widgets/landingpage/custom_app_bar.dart';
import 'package:budgetit/shared/widgets/landingpage/hero_section.dart';
import 'package:budgetit/shared/widgets/landingpage/import_section.dart';
import 'package:budgetit/shared/widgets/landingpage/how_it_works.dart';
import 'package:budgetit/shared/widgets/landingpage/download_section.dart';
import 'package:budgetit/shared/widgets/landingpage/about_section.dart';
import 'package:budgetit/shared/widgets/landingpage/footer.dart';
import 'package:budgetit/utils/app_colour.dart';


Widget _wrap() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      extensions: [MyColours.lightTheme],
    ),
  );
}


void main() {

  group('Landing Page', () {
    testWidgets('builds without throwing and show a scaffold', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(LandingPage), findsOneWidget);
    });

    testWidgets('renders every top-level section exactly once', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.byType(HeroSection), findsOneWidget);
      expect(find.byType(ImportSection), findsOneWidget);
      expect(find.byType(HowItWorks), findsOneWidget);
      expect(find.byType(DownloadSection), findsOneWidget);
      expect(find.byType(AboutSection), findsOneWidget);
      expect(find.byType(Footer), findsOneWidget);
    });    

    testWidgets('sections are laid out in a single scrollable column in the documented order', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      final heroY = tester.getTopLeft(find.byType(HeroSection)).dy;
      final importY = tester.getTopLeft(find.byType(ImportSection)).dy;
      final howItWorksY = tester.getTopLeft(find.byType(HowItWorks)).dy;
      final downloadY = tester.getTopLeft(find.byType(DownloadSection)).dy;
      final aboutY = tester.getTopLeft(find.byType(AboutSection)).dy;
      final footerY = tester.getTopLeft(find.byType(Footer)).dy;

      expect(heroY, lessThan(importY));
      expect(importY, lessThan(howItWorksY));
      expect(howItWorksY, lessThan(downloadY));
      expect(downloadY, lessThan(aboutY));
      expect(aboutY, lessThan(footerY));
    });

    testWidgets('the nav bar is pinned above the scroll content (Stack overlay)', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byType(Stack), findsOneWidget);
      final navBarTop = tester.getTopLeft(find.byType(CustomAppBar)).dy;
      expect(navBarTop, equals(0.0));
    });

    testWidgets('CustomAppBar starts with "Home" as the active section', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      final appBar = tester.widget<CustomAppBar>(find.byType(CustomAppBar));
      expect(appBar.activeSection, equals('Home'));
    });





  });



}