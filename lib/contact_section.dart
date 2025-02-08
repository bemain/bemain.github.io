import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/theme.dart';
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

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: windowSize.margin.add(EdgeInsets.only(
          top: 32,
          bottom: 24,
        )),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (WindowSize.of(context)) {
      case WindowSize.compact:
      case WindowSize.medium:
        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            _buildTitle(context),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 240),
              child: _buildTextSection(context),
            ),
            _buildAddressSection(context),
            _buildSocialSection(context),
            _buildCopyright(context),
          ],
        );
      case WindowSize.expanded:
      case WindowSize.large:
      case WindowSize.extraLarge:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 24,
          children: [
            _buildTitle(context),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1024),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: "Looking for my writing? \nLook here!",
                        style: descriptionTextStyle(context),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go("/writing");
                          },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 340),
                        child: _buildTextSection(context),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: _buildAddressSection(
                      context,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            _buildSocialSection(context),
            _buildCopyright(context),
          ],
        );
    }
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "Contact details",
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTextSection(
    BuildContext context, {
    TextAlign textAlign = TextAlign.center,
  }) {
    return Text(
      """Want to work together, or just interested in knowing more about what I do? Don't hesitate to reach out! I'm always eager to hear from and be inspired by fellow developers.""",
      style: descriptionTextStyle(context),
      textAlign: textAlign,
    );
  }

  Widget _buildAddressSection(
    BuildContext context, {
    TextAlign textAlign = TextAlign.center,
  }) {
    return Column(
      crossAxisAlignment: switch (textAlign) {
        TextAlign.right || TextAlign.end => CrossAxisAlignment.end,
        TextAlign.left || TextAlign.start => CrossAxisAlignment.start,
        _ => CrossAxisAlignment.center,
      },
      spacing: 4,
      children: [
        Text(
          "Benjamin Agardh",
          textAlign: textAlign,
        ),
        Text(
          "Gothenburg, Sweden",
          style: descriptionTextStyle(context),
          textAlign: textAlign,
        ),
        RichText(
          textAlign: textAlign,
          text: TextSpan(
            text: "benjamin@agardh.se",
            style: descriptionTextStyle(context)?.copyWith(
              color: Theme.of(context).colorScheme.primary.withAlpha(0xaa),
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
    );
  }

  Widget _buildSocialSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        for (final socialPlatform in socialPlatforms)
          _buildSocialButton(context, socialPlatform),
      ],
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

  Widget _buildCopyright(BuildContext context) {
    return Text(
      "© ${DateTime.now().year} Benjamin Agardh",
      style: descriptionTextStyle(context),
      textAlign: TextAlign.center,
    );
  }
}
