import 'package:json_annotation/json_annotation.dart';
import 'package:survey_app/configs/utilities/constants/enums/survey_status.dart';
import 'package:survey_app/features/home/survey/domain/models/question.dart';
part 'survey_form.g.dart';

@JsonSerializable(explicitToJson: true)
class SurveyForm{
  String id;
  final String title;
  final List<Question> questions;
  final bool isLoading;
  String? formStatus;

  SurveyForm({this.id = '', required this.title, required this.questions, this.isLoading = true, this.formStatus });

  factory SurveyForm.fromJson(Map<String, dynamic> json){
   return SurveyForm(
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => _$SurveyFormToJson(this);

  bool isSubmitted() {
    return formStatus?.toLowerCase() == SurveyStatus.submitted.name;
  }

  bool isPending() {
    return formStatus?.toLowerCase() == SurveyStatus.pending.name;
  }
}