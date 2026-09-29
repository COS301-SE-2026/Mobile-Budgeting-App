import 'package:flutter/material.dart';
import '../../../utils/app_colour.dart';
import 'package:url_launcher/url_launcher.dart';
import 'landing_responsive.dart';

class DownloadSection extends StatelessWidget {
  const DownloadSection({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.isMobile;
    final colours = context.colours;

    return Container(
      width: double.infinity,
      color: colours.background,
      padding: EdgeInsets.symmetric(
          horizontal: context.sectionHPadding, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Download the app",
            style: TextStyle(
              color: colours.whiteAccents,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              "Install the APK directly. No store account, no sign-up, "
              "and everything runs on your device.",
              style: TextStyle(
                color: colours.whiteAccents.withValues(alpha: 0.8),
                fontSize: 16,
                height: 1.6,
                fontFamily: 'JetBrainsMono',
              ),
            ),
          ),
          const SizedBox(height: 40),
          compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _PlatformBadge(
                        icon: Icons.android_rounded, label: "ANDROID BASED"),
                    SizedBox(height: 28),
                    _DownloadButton(
                      label: "Download the app",
                      url:
                          'https://budgetit-apk-releases.s3.eu-north-1.amazonaws.com/apk-releases/budgetit-manual-test.apk',
                    ),
                    SizedBox(height: 14),
                    _DownloadButton(
                      label: "Download bsg",
                      url:
                          'https://budgetit-apk-releases.s3.eu-north-1.amazonaws.com/apk-releases/budgetit-bsg.apk',
                      outlined: true,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: _PlatformBadge(
                          icon: Icons.android_rounded, label: "ANDROID BASED"),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          _DownloadButton(
                            label: "Download the app",
                            url:
                                'https://budgetit-apk-releases.s3.eu-north-1.amazonaws.com/apk-releases/budgetit-manual-test.apk',
                          ),
                          SizedBox(height: 14),
                          _DownloadButton(
                            label: "Download bsg",
                            url:
                                'https://budgetit-apk-releases.s3.eu-north-1.amazonaws.com/apk-releases/budgetit-bsg.apk',
                            outlined: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PlatformBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final compact = context.isMobile;
    return Row(
      children: [
        Container(
          width: compact ? 80 : 110,
          height: compact ? 80 : 110,
          decoration: BoxDecoration(
            color: colours.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, size: compact ? 44 : 60, color: colours.greenAccents),
        ),
        const SizedBox(width: 24),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: colours.greenAccents,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              height: 1.4,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
        ),
      ],
    );
  }
}

class _DownloadButton extends StatefulWidget {
  final String label;
  final String url;
  final bool outlined;

  const _DownloadButton({
    required this.label,
    required this.url,
    this.outlined = false,
  });

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _launching = false;

  Future<void> _handleDownload() async {
    setState(() => _launching = true);
    try {
      final uri = Uri.parse(widget.url);
      final launched = await launchUrl(uri, webOnlyWindowName: '_blank');
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not start download.')),
        );
      }
    } finally {
      if (mounted) setState(() => _launching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final child = _launching
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colours.background,
            ),
          )
        : Text(
            widget.label,
            style: TextStyle(
                color: colours.background,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                fontFamily: 'SpaceGrotesk'),
          );

    if (widget.outlined) {
      return SizedBox(
        width: 260,
        height: 64,
        child: OutlinedButton(
          onPressed: _launching ? null : _handleDownload,
          style: OutlinedButton.styleFrom(
            backgroundColor: kCream,
            foregroundColor: colours.background,
            side: const BorderSide(color: Colors.black, width: 3),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: 260,
      height: 64,
      child: ElevatedButton(
        onPressed: _launching ? null : _handleDownload,
        style: ElevatedButton.styleFrom(
          backgroundColor: colours.secondary,
          foregroundColor: colours.background,
          elevation: 0,
          side: const BorderSide(color: Colors.black, width: 3),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape:
              const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: child,
      ),
    );
  }
}
