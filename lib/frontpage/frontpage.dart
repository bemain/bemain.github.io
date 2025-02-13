import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:collection/collection.dart';
import 'package:portfolio/frontpage/about_section.dart';
import 'package:portfolio/frontpage/contact_section.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/frontpage/projects_section.dart';
import 'package:portfolio/frontpage/timeline_section.dart';
import 'package:portfolio/frontpage/title_section.dart';

class Frontpage extends StatefulWidget {
  /// The main page of the portfolio.
  /// This page contains the following sections:
  /// - Title section with a butterfly nodegraph and a "Get in touch" button
  /// - About me section with a short description of me
  /// - Timeline section with a timeline of my education and work experience
  /// - Projects section with a list of my projects
  /// - Contact section with links to my social platforms
  const Frontpage({super.key});

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

  @override
  State<Frontpage> createState() => _FrontpageState();
}

class _FrontpageState extends State<Frontpage> {
  /// The key of the primary scaffold. Used to open and close the drawer.
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey aboutMeSectionKey = GlobalKey(debugLabel: "aboutMeSection");
  final GlobalKey timelineSectionKey = GlobalKey(debugLabel: "timelineSection");
  final GlobalKey projectsSectionKey = GlobalKey(debugLabel: "projectsSection");
  final GlobalKey contactSectionKey = GlobalKey(debugLabel: "contactSection");

  late final List<GlobalKey> sectionKeys = [
    aboutMeSectionKey,
    timelineSectionKey,
    projectsSectionKey,
    contactSectionKey,
  ];

  /// The index of the currently selected destination.
  int? selectedDestinationIndex;

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  Future<void> scrollTo(GlobalKey key) async {
    await Scrollable.ensureVisible(
      key.currentContext!,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onDestinationSelected(BuildContext context, int index) async {
    await scrollTo(sectionKeys[index]);
    setState(() {
      selectedDestinationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBar(context, windowSize),
      drawer: _buildDrawer(context, windowSize),
      body: NotificationListener<ScrollNotification>(
        child: SingleChildScrollView(
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
                    scrollTo(contactSectionKey);
                  },
                  onScrollDownPressed: () {
                    scrollTo(aboutMeSectionKey);
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
        onNotification: (ScrollNotification scroll) {
          final Iterable<int?> visibleIndices = sectionKeys.mapIndexed(
              (index, key) => _isVisible(key, scroll) ? index : null);

          setState(() {
            selectedDestinationIndex =
                visibleIndices.lastWhereOrNull((index) => index != null);
          });

          return false;
        },
      ),
    );
  }

  bool _isVisible(
    GlobalKey key,
    ScrollNotification scroll, {
    double offsetMargin = 128,
  }) {
    final RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject == null) return false;

    final viewport = RenderAbstractViewport.of(renderObject);
    final offsetToRevealTop = viewport.getOffsetToReveal(renderObject, 0.0);

    return scroll.metrics.pixels > offsetToRevealTop.offset - offsetMargin;
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
            for (final destination in Frontpage.destinations)
              _buildAppBarDestination(context, destination)
          ],
        );
    }
  }

  Widget _buildAppBarDestination(
    BuildContext context,
    NavigationDrawerDestination destination, {
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    final int index = Frontpage.destinations.indexOf(destination);
    if (index == selectedDestinationIndex) {
      return FilledButton.tonalIcon(
        onPressed: () {},
        style: FilledButton.styleFrom(
          padding: padding,
        ),
        label: destination.label,
        icon: destination.icon,
      );
    }

    return TextButton.icon(
      onPressed: () {
        _onDestinationSelected(
          context,
          Frontpage.destinations.indexOf(destination),
        );
      },
      style: TextButton.styleFrom(
        padding: padding,
      ),
      label: destination.label,
      icon: destination.icon,
    );
  }

  Widget? _buildDrawer(BuildContext context, WindowSize windowSize) {
    switch (windowSize) {
      case WindowSize.compact:
      case WindowSize.medium:
        return NavigationDrawer(
          selectedIndex: selectedDestinationIndex,
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
            ...Frontpage.destinations,
            // const Padding(
            //   padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            //   child: Divider(),
            // ),
          ],
        );

      default:
        return null;
    }
  }
}
