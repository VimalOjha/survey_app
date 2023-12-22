import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survey_app/features/home/survey/domain/models/question.dart';

class SurveyFormCreateRequest {
  Timestamp createdAt;
  final String title;
  final List<Question> questions;

  SurveyFormCreateRequest({required this.title, required this.createdAt, required this.questions});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'createdAt': Timestamp.now().toString(),
      'questions': questions.map((e) => e.toJson()).toList()
    };
  }
  factory SurveyFormCreateRequest.fromJson(Map<String, dynamic> json) {
    return SurveyFormCreateRequest(
      title: json['title'] as String,
      createdAt: json['createdAt'] as Timestamp,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }


}