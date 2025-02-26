import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/theme.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:url_launcher/link.dart';

enum EventType {
  education,
  work,
  coding,
  music,
  award,
  other,
}

class Event {
  const Event({
    required this.title,
    required this.type,
    this.summary,
    this.description,
    this.location,
    this.dateString,
    this.link,
  });

  /// The title of the event.
  final String title;

  final EventType type;

  /// Where the event took place.
  /// TODO: Show this somewhere? Make clickable?
  final String? location;

  /// A short summary of the event. Shown in places with less space, such as on smaller screen.
  final String? summary;

  /// A longer description of the event.
  final String? description;

  /// A string representation of the date of the event.
  final String? dateString;

  /// The link that is opened when this event is clicked.
  final Uri? link;
}

class TimelineSection extends StatefulWidget {
  /// Creates a section with a timeline of events.
  ///
  /// Initially, only [initialEventsShown] events are shown. A button to show more events is displayed if there are more events to show.
  const TimelineSection({super.key, this.initialEventsShown = 6});

  static final List<Event> events = [
    Event(
      dateString: "Spring 2025",
      title: "Conductor in the musical 'The Sound of Music'",
      type: EventType.music,
      location: "Helsingborgs Stadsteater",
      summary: "Conducted the band and arranged the music.",
      description:
          """The musical Sound of Music was staged on one of Skåne's largest stages. I arranged the music for the three-hour long play and conducted the band.""",
      link:
          Uri.parse("https://www.facebook.com/profile.php?id=100089810478596"),
    ),
    Event(
      dateString: "2024 - present",
      title: "Chalmers University of Technology",
      type: EventType.education,
      location: "Gothenburg, Sweden",
      summary: "Engineering Mathematics",
      description: """Began studies in Engineering Mathematics.""",
      link: Uri.parse(
          "https://www.chalmers.se/utbildning/hitta-program/teknisk-matematik-civilingenjor/"),
    ),
    Event(
      dateString: "Autumn 2023",
      title: "EC Solutions",
      type: EventType.work,
      location: "Helsingborg, Sweden",
      summary: "Consulting firm",
      description:
          """I worked in-house at the consulting firm EC Solutions to develop a digital service and website for the company Dirma using Next.js and TypeScript.""",
      link: Uri.parse("https://www.ecsolutions.se/"),
    ),
    Event(
      dateString: "2021, 2022, 2023",
      title: "Arranged larp",
      type: EventType.other,
      location: "Oxdjupet, Vittsjö",
      summary: "Arranged a larp for 30 people",
      description:
          """An activity where 30 people engage in improvised theater and solve challenges during a day. I started it in 2021 and have organized it 3 years in a row.""",
      // TODO: Add link
    ),
    Event(
      dateString: "Spring 2023",
      title: "Conductor in the musical 'Annie'",
      type: EventType.music,
      location: "Helsingborgs Stadsteater, Lunds Stadsteater",
      summary: "Conducted the band and arranged the music.",
      description:
          """The Broadway musical Annie was staged in Lund and Helsingborg, and I conducted the band of 12 people and arranged much of the music. I also appeared on stage as one of the actors.""",
      link: Uri.parse("https://photos.app.goo.gl/dk2aGP8XyN8JSPWD7"),
    ),
    Event(
      dateString: "2022",
      title: "Award, Anderssons minnesfond",
      type: EventType.award,
      summary: "Musical award given to talented youths.",
      description:
          """Musical award given to talented youths in the municipality of Helsingborg, to be used for continued studies in classical music.""",
      link: Uri.parse(
          "https://stiftelsemedel.se/stiftelsen-elsa-och-hellertz-anderssons-minnesfond/"),
    ),
    Event(
      dateString: "2021",
      title: "Award, Lund diocese",
      type: EventType.award,
      summary: "Award given to musically engaged youths.",
      description:
          """Yearly award given to musically engaged youths in the Lund diocese.""",
      link: Uri.parse(
          "https://www.svenskakyrkan.se/lundsstift/nyheter/sok-stiftets-musikstipendium-for-unga"),
    ),
    Event(
      dateString: "2020 - 2022",
      title: "Coding instructor at Hemkodat",
      type: EventType.work,
      location: "Lund, Sweden",
      summary: "Taught children to code.",
      description:
          """I worked to teach children and young people to code, something that I find both fun and important. There were courses in Roblox, Minecraft and Python, and in addition to holding workshops digitally, I also trained new instructors.""",
      link: Uri.parse("https://www.hemkodat.se/"),
    ),
    Event(
      dateString: "2020 - 2023",
      title: "Lars-Erik Larsson-gymnasiet",
      type: EventType.education,
      location: "Lund, Sweden",
      summary: "Natural Science, Music",
      description: """Studied Natural Science, Music. 
Grade: 22,41""",
      link: Uri.parse("https://lel.nu/"),
    ),
    Event(
      dateString: "Summer 2017",
      title: "Mattekollo",
      type: EventType.other,
      location: "Karlskrona, Sweden",
      summary: "Summer camp for mathematically gifted children.",
      description:
          """Summer camp for children and young people who are gifted in and interested in mathematics and programming.""",
      link: Uri.parse("https://www.mattekollo.se/"),
    ),
  ];

  /// The number of events shown initially.
  final int initialEventsShown;

  @override
  State<TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<TimelineSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    final List<Event> events = isExpanded
        ? TimelineSection.events
        : TimelineSection.events.sublist(
            0,
            min(widget.initialEventsShown, TimelineSection.events.length),
          );

    return Padding(
      padding: windowSize.margin.add(EdgeInsets.symmetric(vertical: 32)),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1024),
          child: Column(
            crossAxisAlignment: switch (windowSize) {
              WindowSize.compact => CrossAxisAlignment.start,
              _ => CrossAxisAlignment.center,
            },
            children: [
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerLow,
                radius: 24,
                child: Icon(Icons.event_outlined),
              ),
              const SizedBox(height: 8),
              FixedTimeline.tileBuilder(
                theme: _buildTheme(context),
                builder: TimelineTileBuilder(
                  itemCount: events.length,
                  contentsAlign: switch (windowSize) {
                    WindowSize.compact => ContentsAlign.basic,
                    _ => ContentsAlign.alternating,
                  },
                  contentsBuilder: (context, index) {
                    return _buildEventTile(context, events[index]);
                  },
                  startConnectorBuilder: (context, index) =>
                      SolidLineConnector(),
                  endConnectorBuilder: (context, index) =>
                      (index == TimelineSection.events.length - 1)
                          ? null
                          : SolidLineConnector(),
                  indicatorBuilder: (context, index) => ContainerIndicator(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Icon(
                        _getIcon(events[index]),
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withAlpha(0xaa),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (!isExpanded && events.length < TimelineSection.events.length)
                Align(
                  alignment: windowSize == WindowSize.compact
                      ? Alignment.centerLeft
                      : Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: IconButton.outlined(
                      onPressed: () {
                        setState(() {
                          isExpanded = true;
                        });
                      },
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  TimelineThemeData _buildTheme(BuildContext context) {
    return TimelineThemeData(
      nodePosition: switch (WindowSize.of(context)) {
        WindowSize.compact => 0,
        _ => 0.5,
      },
      connectorTheme: ConnectorThemeData(
        color: Theme.of(context).dividerColor,
      ),
      indicatorTheme: IndicatorThemeData(
        color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(0xaa),
      ),
      color: Theme.of(context).colorScheme.primary,
    );
  }

  IconData _getIcon(Event event) {
    switch (event.type) {
      case EventType.education:
        return Icons.school_outlined;
      case EventType.work:
        return Icons.work_outline;
      case EventType.coding:
        return Icons.code_outlined;
      case EventType.music:
        return Icons.music_note_outlined;
      case EventType.award:
        return Icons.emoji_events_outlined;
      case EventType.other:
        return Icons.radio_button_checked_outlined;
    }
  }

  Widget _buildEventTile(BuildContext context, Event event) {
    final WindowSize windowSize = WindowSize.of(context);
    final String? description = switch (windowSize) {
      WindowSize.compact || WindowSize.medium => event.summary,
      _ => event.description
    };

    Widget content = Link(
      uri: event.link,
      builder: (context, followLink) {
        return InkWell(
          onTap: followLink,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: [
                if (event.dateString != null)
                  Text(
                    event.dateString!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (description != null)
                  Text(
                    description,
                    style: descriptionTextStyle(context),
                  ),
              ],
            ),
          ),
        );
      },
    );

    switch (windowSize) {
      case WindowSize.compact:
        // On small screens, don't wrap the content in a card
        return ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: Material(
            child: content,
          ),
        );

      default:
        return Card.outlined(
          clipBehavior: Clip.antiAlias,
          child: content,
        );
    }
  }
}
