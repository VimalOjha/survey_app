// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      questionLabel: json['label'] as String?,
      questionText: json['question'] as String,
      type: json['type'] as String,
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'question': instance.questionText,
      'label': instance.questionLabel,
      'type': instance.type,
      'options': instance.options,
    };
