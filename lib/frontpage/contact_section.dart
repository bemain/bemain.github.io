import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/theme.dart';
import 'package:url_launcher/link.dart';

class SocialLink {
  const SocialLink({
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
  const ContactSection({super.key});

  static final List<SocialLink> socialPlatforms = [
    SocialLink(
      name: "GitHub",
      icon: AssetImage("assets/icons/github-mark.png"),
      uri: Uri.parse("https://github.com/bemain"),
    ),
    SocialLink(
      name: "LinkedIn",
      icon: AssetImage("assets/icons/LI-In-Bug.png"),
      uri: Uri.parse("https://www.linkedin.com/in/benjamin-agardh"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    return Padding(
      padding: windowSize.margin.add(EdgeInsets.only(
        top: 32,
        bottom: 24,
      )),
      child: _buildContent(context),
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
            _buildWritingLink(context),
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
                    child: _buildWritingLink(
                      context,
                      textAlign: TextAlign.left,
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
            SizedBox(height: 0), // This still adds space due to the `spacing`
            _buildSocialSection(context),
            _buildCopyright(context),
          ],
        );
    }
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "Get in touch",
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildWritingLink(
    BuildContext context, {
    TextAlign textAlign = TextAlign.center,
  }) {
    return Link(
      uri: Uri.parse("/writing"),
      builder: (context, followLink) {
        return RichText(
          textAlign: textAlign,
          text: TextSpan(
            children: [
              TextSpan(text: "Looking for my writing?\n"),
              TextSpan(
                text: "Look here!",
                style: descriptionTextStyle(context)?.copyWith(
                  color: Theme.of(context).colorScheme.primary.withAlpha(0xaa),
                ),
                recognizer: TapGestureRecognizer()..onTap = followLink,
              ),
            ],
            style: descriptionTextStyle(context),
          ),
        );
      },
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
        Link(
          uri: Uri.parse("mailto:benjamin@agardh.se"),
          builder: (context, followLink) {
            return RichText(
              textAlign: textAlign,
              text: TextSpan(
                text: "benjamin@agardh.se",
                style: descriptionTextStyle(context)?.copyWith(
                  color: Theme.of(context).colorScheme.primary.withAlpha(0xaa),
                ),
                recognizer: TapGestureRecognizer()..onTap = followLink,
              ),
            );
          },
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
    SocialLink socialPlatform,
  ) {
    return Link(
      uri: socialPlatform.uri,
      builder: (context, followLink) {
        return IconButton.outlined(
          onPressed: followLink,
          icon: Image(
            image: socialPlatform.icon,
            color: Theme.of(context).colorScheme.onSurface,
            width: 24,
            height: 24,
          ),
        );
      },
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
