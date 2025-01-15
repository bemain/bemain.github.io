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

  final String name;
  final ImageProvider icon;
  final Uri uri;
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.windowSize});

  final WindowSize windowSize;

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
    final Color subtitleColor =
        Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(0xaa);
    final TextStyle? descriptionStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: subtitleColor,
            );

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: windowSize.padding.add(EdgeInsets.only(top: 32, bottom: 12)),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        """Want to work together? Please get in touch! 
I'm always eager to hear from and be inspired by fellow developers!""",
                        style: descriptionStyle,
                      ),
                    ],
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
