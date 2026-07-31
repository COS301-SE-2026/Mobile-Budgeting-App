import 'package:flutter/material.dart';
import '../../../utils/app_colour.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadSection extends StatelessWidget {
  const DownloadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.colours.background,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _PlatformBadge(
                  icon: Icons.android_rounded,
                  label: "ANDROID BASED",
                ),
              ),
              _DownloadButton(),
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

  const _PlatformBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    return Row(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: context.colours.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 60, color: colours.greenAccents),
        ),
        const SizedBox(width: 24),
        Text(
          label,
          style: TextStyle(
            color: colours.greenAccents,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _DownloadButton extends StatefulWidget {
  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  static const _downloadUrl =
      'https://budgetit-apk-releases.s3.eu-north-1.amazonaws.com/apk-releases/budgetit-manual-test.apk';

  bool _launching = false;

  Future<void> _handleDownload() async { //used claude for helper function errors
    setState(() => _launching = true);
    try {
      final uri = Uri.parse(_downloadUrl);
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
    return ElevatedButton(
      onPressed: _launching ? null : _handleDownload,
      style: ElevatedButton.styleFrom(
        backgroundColor: colours.secondary,
        foregroundColor: context.colours.background,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: _launching
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colours.background,
              ),
            )
          : const Text(
              "Download the app",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
    );
  }
}