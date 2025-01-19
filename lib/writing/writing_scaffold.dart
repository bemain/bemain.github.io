import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/layout.dart';

class WritingScaffold extends StatelessWidget {
  const WritingScaffold({super.key, this.body});

  final Widget? body;

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
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Row(
                children: [
                  _buildHomeLogo(context),
                  SizedBox(width: 8),
                  // TODO: Maybe add some text here?
                ],
              ),
            ),
            ...destinations,
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
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
    return Center(
      child: FittedBox(
        fit: BoxFit.cover,
        child: Card.outlined(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.go("/writing");
            },
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Image.asset(
                "assets/logo/butterfly.png",
                width: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
