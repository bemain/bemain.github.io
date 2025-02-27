// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      links: json['links'] == null
          ? const []
          : _linksFromJson(json['links'] as List<Map<String, dynamic>>),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'links': _linksToJson(instance.links),
    };

ProjectLink _$ProjectLinkFromJson(Map<String, dynamic> json) => ProjectLink(
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      uri: Uri.parse(json['uri'] as String),
    );

Map<String, dynamic> _$ProjectLinkToJson(ProjectLink instance) =>
    <String, dynamic>{
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'uri': instance.uri.toString(),
    };
