import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/layout.dart';

class WritingScaffold extends StatelessWidget {
  WritingScaffold({super.key, this.body});

  final Widget? body;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static final List<NavigationDrawerDestination> destinations = [
    NavigationDrawerDestination(
      icon: Icon(Icons.person_outline),
      label: Text("About me"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.work_outline),
      label: Text("Projects"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.mail_outline),
      label: Text("Contact"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: switch (WindowSize.of(context)) {
        WindowSize.compact => _buildNavigation(context),
        _ => null,
      },
      appBar: _buildAppBar(context),
      body: switch (WindowSize.of(context)) {
        WindowSize.compact => body,
        _ => Row(
            children: [
              _buildNavigation(context),
              if (body != null)
                Expanded(
                  child: body!,
                ),
            ],
          )
      },
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    switch (WindowSize.of(context)) {
      case WindowSize.compact:
        return AppBar();

      default:
        return null;
    }
  }

  Widget _buildNavigation(BuildContext context) {
    switch (WindowSize.of(context)) {
      case WindowSize.compact:
      case WindowSize.large:
      case WindowSize.extraLarge:
        return NavigationDrawer(
          selectedIndex: null,
          onDestinationSelected: (value) {},
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 24, 8, 8),
              child: _buildHomeLogo(context),
            ),
            ...destinations,
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 16, 28, 8),
              child: Divider(),
            ),
          ],
        );

      case WindowSize.medium:
      case WindowSize.expanded:
        return NavigationRail(
          selectedIndex: null,
          onDestinationSelected: (int index) {},
          labelType: NavigationRailLabelType.all,
          leading: _buildHomeLogo(context),
          destinations: [
            for (final destination in destinations)
              NavigationRailDestination(
                icon: destination.icon,
                label: destination.label,
              )
          ],
        );
    }
  }

  Widget _buildHomeLogo(BuildContext context) {
    final Widget image = Center(
      child: FittedBox(
        fit: BoxFit.cover,
        child: Card.outlined(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: SvgPicture.asset(
              "assets/logo/butterfly.svg",
              semanticsLabel: "Moments Logo",
              width: 40,
            ),
          ),
        ),
      ),
    );

    onTap() {
      scaffoldKey.currentState?.closeDrawer();
      GoRouter.of(context).go("/writing");
    }

    switch (WindowSize.of(context)) {
      case WindowSize.compact:
      case WindowSize.large:
      case WindowSize.extraLarge:
        return Material(
          type: MaterialType.transparency,
          child: _LogoInkWell(
            onTap: onTap,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            indicatorOffset: Offset(28, 4),
            applyXOffset: true,
            indicatorSize: Size(48, 48),
            child: Row(
              children: [
                image,
                SizedBox(width: 8),
                Text(
                  "Moments",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      case WindowSize.medium:
      case WindowSize.expanded:
        return Column(
          children: [
            SizedBox(height: 12),
            Material(
              type: MaterialType.transparency,
              child: _LogoInkWell(
                onTap: onTap,
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorOffset: Offset(0, 4),
                applyXOffset: false,
                indicatorSize: Size(48, 48),
                child: Column(
                  children: [
                    image,
                    SizedBox(height: 8),
                    Text(
                      "Moments",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        );
    }
  }
}

class _LogoInkWell extends InkResponse {
  const _LogoInkWell({
    super.child,
    super.onTap,
    super.customBorder,
    required this.indicatorOffset,
    this.applyXOffset = false,
    required this.indicatorSize,
  }) : super(
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
        );

  /// The offset used to position Ink highlight.
  final Offset indicatorOffset;

  // Whether the horizontal offset from indicatorOffset should be used to position Ink highlight.
  // If true, Ink highlight uses the indicator horizontal offset. If false, Ink highlight is centered horizontally.
  final bool applyXOffset;

  /// The size of the Ink highlight.
  final Size indicatorSize;

  @override
  RectCallback? getRectCallback(RenderBox referenceBox) {
    final double boxWidth = referenceBox.size.width;
    double indicatorHorizontalCenter =
        applyXOffset ? indicatorOffset.dx : boxWidth / 2;

    return () {
      return Rect.fromLTWH(
        indicatorHorizontalCenter - (indicatorSize.width / 2),
        indicatorOffset.dy,
        indicatorSize.width,
        indicatorSize.height,
      );
    };
  }
}
