// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyForm _$SurveyFormFromJson(Map<String, dynamic> json) => SurveyForm(
      id: json['id'] as String? ?? '',
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLoading: json['isLoading'] as bool? ?? true,
      formStatus: json['formStatus'] as String?,
    );

Map<String, dynamic> _$SurveyFormToJson(SurveyForm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
      'isLoading': instance.isLoading,
      'formStatus': instance.formStatus,
    };
