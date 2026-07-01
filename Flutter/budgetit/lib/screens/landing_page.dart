import 'package:flutter/material.dart';

import '../components/landingpage/custom_app_bar.dart';
import '../components/landingpage/hero_section.dart';
// import '../components/landingpage/features_section.dart';
// import '../components/landingpage/import_section.dart';
// import '../components/landingpage/how_it_works.dart';
import '../components/landingpage/download_section.dart';
import '../components/landingpage/about_section.dart';
import '../components/landingpage/footer.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              CustomAppBar(),

              HeroSection(
                onGetStarted: () {
                // Navigate to the next page
              },
              ),

              // FeaturesSection(),

              // ImportSection(),

              // HowItWorksSection(),

              DownloadSection(),

              AboutSection(),

              Footer(),

            ],
          ),
        ),
      ),
    );
  }
}