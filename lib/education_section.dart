import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';

class Education {
  Education({
    required this.title,
    required this.summary,
    this.description,
    required this.location,
    this.startDate,
    this.endDate,
  })  : // Start date must be before end date
        assert(startDate == null ||
            endDate == null ||
            startDate == endDate ||
            startDate.isBefore(endDate)),
        // If there is an end date, there must be a start date
        assert(startDate != null || endDate == null);

  /// The title of the education. Usually the name of the institution.
  final String title;

  /// Where the education took place.
  final String location;

  /// A short summary of the education.
  final String summary;

  /// A longer description of the education.
  final String? description;

  /// The start date of the education.
  final DateTime? startDate;

  /// The end date of the education. If the education is ongoing, this should be `null`.
  final DateTime? endDate;
}

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  static final List<Education> educations = [
    Education(
      title: "Chalmers University of Technology",
      summary: "Engineering Mathematics",
      location: "Gothenburg, Sweden",
      startDate: DateTime(2024),
    ),
    Education(
      title: "Lars-Erik Larsson-gymnasiet",
      summary: "Natural Science, Music",
      location: "Lund, Sweden",
      startDate: DateTime(2020),
      endDate: DateTime(2023),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    switch (windowSize) {
      case WindowSize.compact:
      case WindowSize.medium:
        return Padding(
          padding: windowSize.margin.add(EdgeInsets.symmetric(vertical: 32)),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerLow,
                    radius: 24,
                    child: Icon(Icons.school_outlined),
                  ),
                  const SizedBox(width: 16),
                  _buildTitle(context),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: 48,
                        child: FractionallySizedBox(
                          heightFactor: 1 - 1 / (educations.length * 2),
                          child: VerticalDivider(),
                        ),
                      ),
                    ),
                  ),
                  IntrinsicHeight(
                    child: Column(
                      children: [
                        for (final education in educations)
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                child: Icon(
                                  Icons.radio_button_checked_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withAlpha(0xaa),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child:
                                      _buildEducationText(context, education),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );

      default:
    }
    return const SizedBox();
  }

  Widget _buildTitle(
    BuildContext context, {
    String text = "Education",
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEducationText(BuildContext context, Education education) {
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
        Text(
          education.title,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.start,
        ),
        Text(
          education.summary,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        if (education.description != null)
          Text(
            education.description!,
            style: descriptionStyle,
          ),
        if (education.startDate != null)
          RichText(
            text: TextSpan(
              style: descriptionStyle,
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child:
                        Icon(Icons.date_range_outlined, color: subtitleColor),
                  ),
                ),
                TextSpan(text: "${education.startDate?.year}"),
                if (education.endDate != education.startDate)
                  TextSpan(
                    text: " - ${education.endDate?.year ?? "present"}",
                  ),
              ],
            ),
          ),
        RichText(
          text: TextSpan(
            style: descriptionStyle,
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.location_on_outlined, color: subtitleColor),
                ),
              ),
              TextSpan(text: education.location),
            ],
          ),
        ),
      ],
    );
  }
}
