import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/layout.dart';

class WritingScaffold extends StatelessWidget {
  /// Wraps [body] with a scaffold that is also populated with navigation elements.
  /// The type of navigation widgets used depend on the current [WindowSize]:
  /// - Modal [NavigationDrawer] for [WindowSize.compact]
  /// - [NavigationRail] for [WindowSize.medium] and [WindowSize.expanded]
  /// - Standard [NavigationDrawer] for [WindowSize.large] and [WindowSize.extraLarge]
  WritingScaffold({super.key, this.title, this.body});

  /// The title shown in the app bar on compact screens.
  final Widget? title;

  /// The main content of the scaffold.
  final Widget? body;

  /// The key of the primary scaffold. Used to open and close the drawer.
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static final List<NavigationDrawerDestination> destinations = [
    NavigationDrawerDestination(
      icon: Icon(Icons.person_outline),
      label: Text("About me"),
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

  void _onDestinationSelected(BuildContext context, int value) {
    switch (value) {
      case 0:
        context.go("/");
    }
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    switch (WindowSize.of(context)) {
      case WindowSize.compact:
        return AppBar(
          title: title,
        );

      default:
        return null;
    }
  }

  Widget _buildNavigation(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    switch (windowSize) {
      case WindowSize.medium:
      case WindowSize.expanded:
        return NavigationRail(
          selectedIndex: null,
          onDestinationSelected: (value) =>
              _onDestinationSelected(context, value),
          labelType: NavigationRailLabelType.all,
          leading: _buildHomeLogo(context, vertical: true),
          destinations: [
            for (final NavigationDrawerDestination destination in destinations)
              NavigationRailDestination(
                icon: destination.icon,
                label: destination.label,
              ),
          ],
        );
      default:
        return NavigationDrawer(
          backgroundColor: switch (windowSize) {
            WindowSize.large ||
            WindowSize.extraLarge =>
              Theme.of(context).colorScheme.surface,
            _ => null,
          },
          elevation: 0,
          selectedIndex: null,
          onDestinationSelected: (value) =>
              _onDestinationSelected(context, value),
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
    }
  }

  Widget _buildHomeLogo(BuildContext context, {bool vertical = false}) {
    final Widget image = Card.outlined(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: SvgPicture.asset(
          "assets/logo/butterfly.svg",
          semanticsLabel: "Moments Logo",
          width: 40,
          height: 40,
        ),
      ),
    );

    onTap() {
      scaffoldKey.currentState?.closeDrawer();
      GoRouter.of(context).go("/writing");
    }

    if (vertical) {
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
