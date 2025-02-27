// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      title: json['title'] as String,
      type: $enumDecode(_$EventTypeEnumMap, json['type']),
      summary: json['summary'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      dateString: json['dateString'] as String?,
      linkUrl: json['linkUrl'] as String?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'title': instance.title,
      'type': _$EventTypeEnumMap[instance.type]!,
      'location': instance.location,
      'summary': instance.summary,
      'description': instance.description,
      'dateString': instance.dateString,
      'linkUrl': instance.linkUrl,
    };

const _$EventTypeEnumMap = {
  EventType.education: 'education',
  EventType.work: 'work',
  EventType.coding: 'coding',
  EventType.music: 'music',
  EventType.award: 'award',
  EventType.other: 'other',
};
