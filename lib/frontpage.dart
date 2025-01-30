import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/about_section.dart';
import 'package:portfolio/contact_section.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/projects_section.dart';
import 'package:portfolio/timeline_section.dart';
import 'package:portfolio/title_section.dart';

class Frontpage extends StatelessWidget {
  Frontpage({super.key});

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
    NavigationDrawerDestination(
      icon: Icon(Icons.notes_outlined),
      label: Text("Moments"),
    ),
  ];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey aboutMeSectionKey = GlobalKey(debugLabel: "aboutMeSection");
  final GlobalKey projectsSectionKey = GlobalKey(debugLabel: "projectsSection");
  final GlobalKey contactSectionKey = GlobalKey(debugLabel: "contactSection");

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBar(context, windowSize),
      drawer: _buildDrawer(context, windowSize),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 48),
            SizedBox(
              height: MediaQuery.sizeOf(context).height -
                  MediaQuery.paddingOf(context).top -
                  kToolbarHeight -
                  48 -
                  MediaQuery.paddingOf(context).bottom,
              child: TitleSection(
                onGetInTouchPressed: () {
                  _scrollTo(contactSectionKey);
                },
              ),
            ),
            AboutMeSection(key: aboutMeSectionKey),
            TimelineSection(),
            ProjectsSection(key: projectsSectionKey),
            ContactSection(key: contactSectionKey),
          ],
        ),
      ),
    );
  }

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == 3) {
      context.go("/writing");
      return;
    }

    _scrollTo(switch (index) {
      0 => aboutMeSectionKey,
      1 => projectsSectionKey,
      2 => contactSectionKey,
      _ => throw "Invalid destination index",
    });
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WindowSize windowSize,
  ) {
    switch (windowSize) {
      case WindowSize.compact:
      case WindowSize.medium:
        return AppBar();

      default:
        return AppBar(
          actions: [
            for (final destination in destinations)
              TextButton.icon(
                onPressed: () {
                  _onDestinationSelected(
                      context, destinations.indexOf(destination));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(24),
                ),
                label: destination.label,
                icon: destination.icon,
              ),
          ],
        );
    }
  }

  Widget? _buildDrawer(BuildContext context, WindowSize windowSize) {
    switch (windowSize) {
      case WindowSize.compact:
      case WindowSize.medium:
        return NavigationDrawer(
          selectedIndex: null,
          onDestinationSelected: (value) {
            _onDestinationSelected(context, value);
            scaffoldKey.currentState?.closeDrawer();
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 16, 16),
              child: Text(
                "Benjamin Agardh",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...destinations,
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 16, 0),
              child: Text(
                """Engineering student with a passion for technology, music, and coding.""",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withAlpha(0xaa),
                    ),
              ),
            ),
          ],
        );

      default:
        return null;
    }
  }

  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
