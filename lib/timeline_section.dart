import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:timelines_plus/timelines_plus.dart';

enum EventType {
  education,
  work,
  coding,
  music,
  award,
  other,
}

class Event {
  // TODO: Add links to events
  const Event({
    required this.title,
    required this.type,
    this.summary,
    this.description,
    this.location,
    this.dateString,
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
}

class TimelineSection extends StatelessWidget {
  const TimelineSection({super.key});

  static final List<Event> events = [
    Event(
      dateString: "Spring 2025",
      title: "Conductor in the musical 'The Sound of Music'",
      type: EventType.music,
      location: "Helsingborgs Stadsteater",
      summary: "Conducted the band and arranged the music.",
      description:
          """The musical Sound of Music was staged on one of Skåne's largest stages. I arranged the music for the three-hour long play and conducted the band.""",
    ),
    Event(
      dateString: "2024 - present",
      title: "Chalmers University of Technology",
      type: EventType.education,
      location: "Gothenburg, Sweden",
      summary: "Engineering Mathematics",
      description: """Began studies in Engineering Mathematics.""",
    ),
    Event(
      dateString: "Autumn 2023",
      title: "EC Solutions",
      type: EventType.work,
      location: "Helsingborg, Sweden",
      summary: "Consulting firm",
      description:
          """I worked in-house at the consulting firm EC Solutions to develop a digital service and website for the company Dirma using Next.js and TypeScript.""",
    ),
    Event(
      dateString: "Spring 2023",
      title: "Conductor in the Broadway musical 'Annie'",
      type: EventType.music,
      location: "Helsingborgs Stadsteater, Lunds Stadsteater",
      summary: "Conducted the band and arranged the music.",
      description:
          """The musical Annie was staged in 2023 at the city theaters in Lund and Helsingborg, and I conducted the band of 12 people and arranged much of the music. I also appeared on stage as one of the actors.""",
    ),
    Event(
      dateString: "2022",
      title: "Award, Anderssons minnesfond",
      type: EventType.award,
      summary: "Musical award given to talented youths.",
      description:
          """Musical award given to talented youths in the municipality of Helsingborg, to be used for continued studies in classical music""",
    ),
    Event(
      dateString: "2021",
      title: "Award, Lund diocese",
      type: EventType.award,
      summary: "Award given to musically engaged youths.",
      description:
          """Yearly award given to musically engaged youths in the Lund diocese.""",
    ),
    Event(
      dateString: "2020 - 2022",
      title: "Coding instructor at Hemkodat",
      type: EventType.work,
      location: "Lund, Sweden",
      summary: "Taught children to code.",
      description:
          """I worked to teach children and young people to code, something that I find both fun and important. There were courses in Roblox, Minecraft and Python, and in addition to holding workshops digitally, I also trained new instructors.""",
    ),
    Event(
      dateString: "2020 - 2023",
      title: "Lars-Erik Larsson-gymnasiet",
      type: EventType.education,
      location: "Lund, Sweden",
      summary: "Natural Science, Music",
      description: """Studied Natural Science, Music. 
Grade: 22,41""",
    ),
    Event(
      dateString: "Summer 2017",
      title: "Mattekollo",
      type: EventType.other,
      location: "Karlskrona, Sweden",
      summary: "Summer camp for mathematically gifted children.",
      description:
          """Summer camp for children and young people who are gifted in and interested in mathematics and programming""",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    return Padding(
      padding: windowSize.margin.add(EdgeInsets.symmetric(vertical: 32)),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1024),
          child: Column(
            children: [
              _buildTitle(context),
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
                    return EventTile(event: events[index]);
                  },
                  startConnectorBuilder: (context, index) =>
                      SolidLineConnector(),
                  endConnectorBuilder: (context, index) =>
                      index == events.length - 1 ? null : SolidLineConnector(),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context, {
    String text = "Timeline",
  }) {
    switch (WindowSize.of(context)) {
      case WindowSize.compact:
        return Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow,
              radius: 24,
              child: Icon(Icons.event_outlined),
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        );

      default:
        return Column(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow,
              radius: 24,
              child: Icon(Icons.event_outlined),
            ),
          ],
        );
    }
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
}

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.event,
    this.layoutDirection = TextDirection.ltr,
  });

  final Event event;

  final TextDirection layoutDirection;

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    final String? description = switch (windowSize) {
      WindowSize.compact || WindowSize.medium => event.summary,
      _ => event.description
    };

    final Color subtitleColor =
        Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(0xaa);
    final TextStyle? descriptionStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: subtitleColor,
            );

    return Card.outlined(
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
                style: descriptionStyle,
              ),
          ],
        ),
      ),
    );
  }
}
