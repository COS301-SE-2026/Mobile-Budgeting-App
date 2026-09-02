import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'hero_section.dart';
import 'import_section.dart';
import 'how_it_works.dart';
import 'download_section.dart';
import 'about_section.dart';
import 'footer.dart';
import '../../../utils/app_colour.dart';

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
  bool _showBackToTop = false;

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
    sections.forEach((name, key) {
      final ctx = key.currentContext;
      if (ctx == null) return;
      final box = ctx.findRenderObject() as RenderBox;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy <= _navBarHeight + 50) {
        final distance = (dy - _navBarHeight).abs();
        if (distance < closest) {
          closest = distance;
          current = name;
        }
      }
    });

    final showTop = _scrollController.hasClients &&
        _scrollController.offset > MediaQuery.of(context).size.height;
    if (current != _activeSection || showTop != _showBackToTop) {
      setState(() {
        _activeSection = current;
        _showBackToTop = showTop;
      });
    }
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _handleLogin() {
    // TODO: route to your login screen.
  }

  void _handleGetStarted() {
    _scrollTo(_downloadKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  HeroSection(
                    key: _homeKey,
                  //  onGetStarted: _handleGetStarted,
//                    onLogin: _handleLogin,
                  ),
                  ImportSection(key: _featuresKey),
                  HowItWorks(key: _howItWorksKey),
                  DownloadSection(key: _downloadKey),
                  AboutSection(key: _aboutKey),
                  const Footer(
                    repoUrl: 'https://github.com/COS301-SE-2026/Mobile-Budgeting-App',
                    contactEmail: 'devoops.cos301@gmail.com',
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              activeSection: _activeSection,
              onHomeTap: () => _scrollTo(_homeKey),
              onFeaturesTap: () => _scrollTo(_featuresKey),
              onHowItWorksTap: () => _scrollTo(_howItWorksKey),
              onDownloadTap: () => _scrollTo(_downloadKey),
              onAboutTap: () => _scrollTo(_aboutKey),
              onLogin: _handleLogin,
              onGetStarted: _handleGetStarted,
            ),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: AnimatedOpacity(
              opacity: _showBackToTop ? 1 : 0,
              duration: const Duration(milliseconds: 220),
              child: IgnorePointer(
                ignoring: !_showBackToTop,
                child: FloatingActionButton.small(
                  onPressed: () => _scrollTo(_homeKey),
                  backgroundColor: context.colours.informational,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.arrow_upward_rounded),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}