import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialPlatform {
  const SocialPlatform({
    required this.name,
    required this.icon,
    required this.uri,
  });

  /// The name of the social platform.
  final String name;

  /// The icon representing the social platform.
  final ImageProvider icon;

  /// The URI to my profile on the social platform.
  final Uri uri;
}

class ContactSection extends StatelessWidget {
  /// A section displaying contact details and links to social platforms.
  /// TODO: Add link to Moments
  const ContactSection({super.key});

  static final List<SocialPlatform> socialPlatforms = [
    SocialPlatform(
      name: "GitHub",
      icon: AssetImage("assets/contact/github-mark.png"),
      uri: Uri.parse("https://github.com/bemain"),
    ),
    SocialPlatform(
      name: "LinkedIn",
      icon: AssetImage("assets/contact/LI-In-Bug.png"),
      uri: Uri.parse("https://www.linkedin.com/in/benjamin-agardh"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    final Color subtitleColor =
        Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(0xaa);
    final TextStyle? descriptionStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: subtitleColor,
            );

    final double extraMargin = switch (windowSize) {
      WindowSize.compact || WindowSize.medium => 0,
      _ => 32,
    };

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: windowSize.margin.add(EdgeInsets.only(
          top: 32,
          right: extraMargin,
          bottom: 12,
          left: extraMargin,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            Text(
              "Contact details",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 320),
                    child: Text(
                      """Want to work together, or just interested in knowing more about what I do? Don't hesitate to reach out! I'm always eager to hear from and be inspired by fellow developers.""",
                      style: descriptionStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Benjamin Agardh"),
                    Text(
                      "Gothenburg, Sweden",
                      style: descriptionStyle,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "benjamin@agardh.se",
                        style: descriptionStyle?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(0xaa),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await launchUrl(
                              Uri.parse("mailto:benjamin@agardh.se"),
                            );
                          },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                for (final socialPlatform in socialPlatforms)
                  _buildSocialButton(context, socialPlatform),
              ],
            ),
            Text(
              "© ${DateTime.now().year} Benjamin Agardh",
              style: descriptionStyle,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    SocialPlatform socialPlatform,
  ) {
    return IconButton.outlined(
      onPressed: () {
        launchUrl(socialPlatform.uri);
      },
      icon: Image(
        image: socialPlatform.icon,
        color: Theme.of(context).colorScheme.onSurface,
        width: 24,
        height: 24,
      ),
    );
  }
}
