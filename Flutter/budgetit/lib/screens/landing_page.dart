import 'package:flutter/material.dart';

import '../components/landingpage/custom_app_bar.dart';
import '../components/landingpage/hero_section.dart';
// import '../components/landingpage/features_section.dart';
// import '../components/landingpage/import_section.dart';
// import '../components/landingpage/how_it_works.dart';
import '../components/landingpage/download_section.dart';
import '../components/landingpage/about_section.dart';
import '../components/landingpage/footer.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();

  final _homeKey = GlobalKey();
  final _featuresKey = GlobalKey();
  final _howItWorksKey = GlobalKey();
  final _downloadKey = GlobalKey();
  final _aboutKey = GlobalKey();

  static const double _navBarHeight = 80;

  String _activeSection = "Home";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveSection);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateActiveSection);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateActiveSection() {
    final sections = {
      "Home": _homeKey,
      "Features": _featuresKey,
      "How it works": _howItWorksKey,
      "Download App": _downloadKey,
      "About": _aboutKey,
    };

    String current = _activeSection;
    double closest = double.infinity;
//this section i used chatgpt to  help me out on how to make the render obejct 
    sections.forEach((name, key) {
      final ctx = key.currentContext;
      if (ctx == null) return;
      final box = ctx.findRenderObject() as RenderBox;
      final dy = box.localToGlobal(Offset.zero).dy;

      // Section counts as "active" once its top has scrolled up
      // to just under the navbar.
      if (dy <= _navBarHeight + 50) {
        final distance = (dy - _navBarHeight).abs();
        if (distance < closest) {
          closest = distance;
          current = name;
        }
      }
    });

    if (current != _activeSection) {
      setState(() => _activeSection = current);
    }
  }

  void _scrollTo(GlobalKey key) {
    final ctx =key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

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