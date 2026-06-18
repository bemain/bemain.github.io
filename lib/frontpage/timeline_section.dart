import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/theme.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:url_launcher/link.dart';

part 'timeline_section.g.dart';

enum EventType {
  education,
  work,
  coding,
  music,
  award,
  other,
}

@JsonSerializable()
class Event {
  const Event({
    required this.title,
    required this.type,
    this.summary,
    this.description,
    this.location,
    this.dateString,
    this.linkUrl,
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
  final String? linkUrl;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Uri? get link {
    if (linkUrl == null) return null;
    return Uri.tryParse(linkUrl!);
  }

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}

class TimelineSection extends StatefulWidget {
  /// Creates a section with a timeline of events.
  ///
  /// Initially, only [initialEventsShown] events are shown. A button to show more events is displayed if there are more events to show.
  const TimelineSection({super.key, this.initialEventsShown = 6});

  static final List<Event> events = [
    Event(
      dateString: "Summer 2026",
      title: "u-blox",
      type: EventType.work,
      location: "Malmö",
      summary: "Evaluating embedded ML for dead-reckoning.",
      description:
          """Evaluating embedded ML for dead-reckoning at u-blox, a global leader in positioning and wireless communication technology.""",
      linkUrl: "https://www.u-blox.com",
    ),
    Event(
      dateString: "Spring 2025, 2026",
      title: "Conductor in the musical 'The Sound of Music'",
      type: EventType.music,
      location: "Helsingborgs Stadsteater, Helsingborg",
      summary: "Conducted the band and arranged the music.",
      description:
          """Sound of Music sold out on one of Skåne's largest stages. I arranged the music for the three-hour production and conducted the band — and liked it so much we did it again the following year.""",
      linkUrl: "https://www.facebook.com/profile.php?id=100089810478596",
    ),
    Event(
      dateString: "2025 - present",
      title: "Chairman, CKG",
      type: EventType.education,
      location: "Gothenburg",
      summary: "Chairman of the student association CKG.",
      description:
          """Chairman of Chalmers Kristna Grupp, a student association organizing lunch lectures and community events for over 80 participants.""",
    ),
    Event(
      dateString: "2024 - present",
      title: "Chalmers University of Technology",
      type: EventType.education,
      location: "Gothenburg",
      summary: "Engineering Mathematics.",
      description:
          """Studying Engineering Mathematics at Chalmers — a program combining advanced mathematics with computer science, physics, and real-world applications.""",
      linkUrl:
          "https://www.chalmers.se/utbildning/hitta-program/teknisk-matematik-civilingenjor/",
    ),
    Event(
      dateString: "Autumn 2023",
      title: "EC Solutions",
      type: EventType.work,
      location: "Helsingborg",
      summary: "Developed a website for Dirma in Next.js and TypeScript.",
      description:
          """Worked in-house at the consulting firm EC Solutions, building a digital service and website for the company Dirma using Next.js and TypeScript.""",
      linkUrl: "https://www.ecsolutions.se/",
    ),
    Event(
      dateString: "2021, 2022, 2023, 2025",
      title: "Arranged larp",
      type: EventType.other,
      location: "Oxdjupet, Vittsjö",
      summary: "Arranged a larp for 30 people.",
      description:
          """A day of improvised theater and puzzle-solving for 30 people in the woods. I started it in 2021 and have organized it every year since.""",
      // TODO: Add link
    ),
    Event(
      dateString: "Spring 2023",
      title: "Conductor in the musical 'Annie'",
      type: EventType.music,
      location: "Helsingborgs Stadsteater, Lunds Stadsteater",
      summary: "Conducted the band and arranged the music.",
      description:
          """The Broadway musical Annie was staged at theatres in both Lund and Helsingborg. I conducted a band of 12 and arranged much of the music — and also appeared on stage as one of the actors.""",
      linkUrl: "https://photos.app.goo.gl/dk2aGP8XyN8JSPWD7",
    ),
    Event(
      dateString: "December 2022",
      title: "Released Musician's Toolbox",
      type: EventType.coding,
      summary: "Launched my Flutter app for musicians on iOS and Android.",
      description:
          """Launched Musician's Toolbox, a Flutter app with everything musicians need for transcribing, practicing, and performing. Available on the App Store and Google Play, and still actively growing.""",
      linkUrl: "https://play.google.com/store/apps/details?id=se.agardh.musbx",
    ),
    Event(
      dateString: "2022",
      title: "Award, Anderssons minnesfond",
      type: EventType.award,
      summary: "Musical scholarship for talented young musicians.",
      description:
          """A musical scholarship awarded to talented young musicians in Helsingborg, to be used for continued studies in classical music.""",
      linkUrl:
          "https://stiftelsemedel.se/stiftelsen-elsa-och-hellertz-anderssons-minnesfond/",
    ),
    Event(
      dateString: "2021",
      title: "Award, Lund diocese",
      type: EventType.award,
      summary: "One of three recipients of the Lund diocese music scholarship.",
      description:
          """One of three yearly recipients of the Lund diocese music scholarship for musically engaged young people.""",
      linkUrl:
          "https://www.svenskakyrkan.se/lundsstift/nyheter/sok-stiftets-musikstipendium-for-unga",
    ),
    Event(
      dateString: "May 2021",
      title: "Säkerhets-SM",
      type: EventType.coding,
      location: "Digitally",
      summary: "Finalist in the National Cybersecurity Championship.",
      description:
          """Finalist in Sweden's National Cybersecurity Championship for high school students.""",
      linkUrl: "https://sakerhetssm.se/",
    ),
    Event(
      dateString: "2020 - 2022",
      title: "Coding instructor at Hemkodat",
      type: EventType.work,
      location: "Lund",
      summary: "Taught children to code.",
      description:
          """Taught children and young people to code — something I find both genuinely fun and important. Courses covered Roblox, Minecraft, and Python. Also trained new instructors.""",
      linkUrl: "https://www.hemkodat.se/",
    ),
    Event(
      dateString: "2021 - 2023",
      title: "Lars-Erik Larsson-gymnasiet",
      type: EventType.education,
      location: "Lund",
      summary: "Natural science with music. Merit 22.41.",
      description:
          """Natural Science with Music. Graduated with a merit of 22.41, having completed Math 4–5 in year one and Specialist Mathematics in year two.""",
      linkUrl: "https://lel.nu/",
    ),
    Event(
      dateString: "Summer 2019",
      title: "Nordiskt talangläger, AI",
      type: EventType.coding,
      location: "BTH, Karlskrona",
      summary: "Nordic talent camp focused on AI and mathematics.",
      description:
          """A summer camp for gifted students from across the Nordic countries, exploring AI and mathematics.""",
      linkUrl:
          "https://mattetalanger.ncm.gu.se/nordiskt-talanglager-inom-artificiell-intelligens/",
    ),
    Event(
      dateString: "Summer 2017",
      title: "Mattekollo",
      type: EventType.education,
      location: "Karlskrona",
      summary: "Summer camp for mathematically gifted children.",
      description:
          """A summer camp for children passionate about mathematics and programming — my first real taste of what it feels like to be in a room full of people who love the same things you do.""",
      linkUrl: "https://www.mattekollo.se/",
    ),
    Event(
      dateString: "2011 - 2020",
      title: "Rydebäcksskolan",
      type: EventType.education,
      location: "Rydebäck",
      summary: "Elementary school. All A's, merit 340.",
      description:
          """Elementary school. Received all A's (merit 340) and completed Math 1–3c during middle school.""",
      linkUrl: "https://helsingborg.se/grundskolor/rydebacksskolan/",
    )
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
              SizedBox(
                width: 48,
                child: M3Container.sunny(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  width: 48,
                  height: 48,
                  child: Icon(Symbols.event),
                ),
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
                      icon: Icon(Symbols.arrow_drop_down),
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
        return Symbols.school;
      case EventType.work:
        return Symbols.work;
      case EventType.coding:
        return Symbols.code;
      case EventType.music:
        return Symbols.music_note;
      case EventType.award:
        return Symbols.emoji_events;
      case EventType.other:
        return Symbols.radio_button_checked;
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
