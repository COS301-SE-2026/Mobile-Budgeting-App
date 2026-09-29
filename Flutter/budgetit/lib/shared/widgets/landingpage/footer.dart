import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/app_colour.dart';
import 'landing_responsive.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
    this.repoUrl,
    this.contactEmail,
    this.privacyUrl,
  });

  final String? repoUrl;
  final String? contactEmail;
  final String? privacyUrl;

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final compact = context.isMobile;

    final links = <Widget>[
      if (repoUrl != null) _FooterLink("GitHub", url: repoUrl!),
      if (contactEmail != null)
        _FooterLink("Contact", url: 'mailto:$contactEmail'),
      if (privacyUrl != null) _FooterLink("Privacy", url: privacyUrl!),
    ];

    return Container(
      width: double.infinity,
      color: colours.background,
      padding: EdgeInsets.fromLTRB(
          context.sectionHPadding, 36, context.sectionHPadding, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 1, color: colours.whiteAccents.withValues(alpha: 0.15)),
          const SizedBox(height: 28),
          Flex(
            direction: compact ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: compact ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Budget IT",
                      style: TextStyle(
                        color: colours.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Your statements never leave your device.",
                      style: TextStyle(
                        color: colours.whiteAccents.withValues(alpha: 0.75),
                        fontSize: 13,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: compact ? 24 : 0),
              Wrap(spacing: 8, runSpacing: 4, children: links),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "© 2026 Dev Oops. All rights reserved.",
            style: TextStyle(
              color: colours.whiteAccents.withValues(alpha: 0.55),
              fontSize: 12,
              fontFamily: 'JetBrainsMono',
            ),
          ),
        ],
      ),
    );
  }
}


class _FooterLink extends StatelessWidget {
  final String label;
  final String url;
  const _FooterLink(this.label, {required this.url});

  Future<void> _open() async {
    final uri = Uri.parse(url);
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    return TextButton(
      onPressed: _open,
      style: TextButton.styleFrom(
        foregroundColor: colours.greenAccents,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colours.whiteAccents,
          fontSize: 13.5,
          fontFamily: 'JetBrainsMono',
        ),
      ),
    );
  }
}