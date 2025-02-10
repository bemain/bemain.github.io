import 'package:flutter/material.dart';
import 'package:portfolio/frontpage/about_section.dart';
import 'package:portfolio/frontpage/contact_section.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/frontpage/projects_section.dart';
import 'package:portfolio/frontpage/timeline_section.dart';
import 'package:portfolio/frontpage/title_section.dart';

class Frontpage extends StatelessWidget {
  /// The main page of the portfolio.
  /// This page contains the following sections:
  /// - Title section with a butterfly nodegraph and a "Get in touch" button
  /// - About me section with a short description of me
  /// - Timeline section with a timeline of my education and work experience
  /// - Projects section with a list of my projects
  /// - Contact section with links to my social platforms
  Frontpage({super.key});

  static final List<NavigationDrawerDestination> destinations = [
    NavigationDrawerDestination(
      icon: Icon(Icons.person_outline),
      label: Text("About me"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.event),
      label: Text("Timeline"),
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey aboutMeSectionKey = GlobalKey(debugLabel: "aboutMeSection");
  final GlobalKey timelineSectionKey = GlobalKey(debugLabel: "timelineSection");
  final GlobalKey projectsSectionKey = GlobalKey(debugLabel: "projectsSection");
  final GlobalKey contactSectionKey = GlobalKey(debugLabel: "contactSection");

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onDestinationSelected(BuildContext context, int index) {
    _scrollTo(switch (index) {
      0 => aboutMeSectionKey,
      1 => timelineSectionKey,
      2 => projectsSectionKey,
      3 => contactSectionKey,
      _ => throw "Invalid destination index",
    });
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
                onScrollDownPressed: () {
                  _scrollTo(aboutMeSectionKey);
                },
              ),
            ),
            AboutMeSection(key: aboutMeSectionKey),
            TimelineSection(key: timelineSectionKey),
            ProjectsSection(key: projectsSectionKey),
            ContactSection(key: contactSectionKey),
          ],
        ),
      ),
    );
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
}
