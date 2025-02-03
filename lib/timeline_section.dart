import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';

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
  const TimelineSection({
    super.key,
    this.iconLineWidth = 48,
    this.tileHeight = 128,
    this.tileSpacing = 32,
  });

  static final List<Event> events = [
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

  final double iconLineWidth;

  final double tileHeight;

  final double tileSpacing;

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    return Padding(
      padding: windowSize.margin.add(EdgeInsets.symmetric(vertical: 32)),
      child: () {
        switch (windowSize) {
          case WindowSize.compact:
          case WindowSize.medium:
            return Column(
              children: [
                const SizedBox(height: 24),
                _buildTitle(context),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: _buildLine(context),
                      ),
                    ),
                    Column(
                      spacing: 12,
                      children: [
                        for (final event in events) EventTile(event: event),
                      ],
                    )
                  ],
                ),
              ],
            );
          case WindowSize.expanded:
          case WindowSize.large:
          case WindowSize.extraLarge:
            return LayoutBuilder(
              builder: (context, constraints) {
                final double tileWidth =
                    iconLineWidth / 2 + constraints.maxWidth / 2;

                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: _buildLine(context),
                      ),
                    ),
                    for (int i = 0; i < events.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          top: (tileHeight / 2 + tileSpacing) * i,
                        ),
                        child: Align(
                          alignment: i % 2 == 0
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: SizedBox(
                            width: tileWidth,
                            child: EventTile(
                              event: events[i],
                              layoutDirection: i % 2 == 0
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
        }
      }(),
    );
  }

  Widget _buildTitle(
    BuildContext context, {
    String text = "Events",
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
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
  }

  Widget _buildLine(BuildContext context) {
    return SizedBox(
      width: iconLineWidth,
      child: FractionallySizedBox(
        heightFactor: 1 - 1 / (events.length * 2),
        child: VerticalDivider(),
      ),
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
    return Row(
      textDirection: layoutDirection,
      children: [
        Container(
          width: 48,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Icon(
            _getIcon(),
            color:
                Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(0xaa),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card.outlined(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: _buildText(context),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIcon() {
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

  Widget _buildText(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    final String? description =
        windowSize == WindowSize.compact ? event.summary : event.description;

    final Color subtitleColor =
        Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(0xaa);
    final TextStyle? descriptionStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: subtitleColor,
            );

    return Column(
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
    );
  }
}
