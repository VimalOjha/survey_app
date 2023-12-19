import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/features/home/survey/domain/models/question.dart';

class UserAnswerModel {
  final String title;
  final List<Question> questions;

  UserAnswerModel({
    required this.title,
    required this.questions,
  });

  Map<String, dynamic> toUserSubmitJson(Map<String,dynamic> dynamicUserInputMap) {
    return {
      'title': title,
      'createdAt': Timestamp.now(),
      'questions': questions
          .asMap()
          .entries
          .map((entry) {
        int index = entry.key;
        Question question = entry.value;
        return {
          'question': question.questionText,
          'type': question.type,
          'label': question.questionLabel,
          'options': question.options,
          'selected_options': question.isTypeRadio() ? dynamicUserInputMap['radio_answer_$index'] :
          question.isTypeMultiSelect() ? dynamicUserInputMap['multichoice_answer_$index'] : null,
          'answer': question.isTypeText() ? (dynamicUserInputMap['text_answer_$index'] as TextEditingController).text : null,
        };
      }).toList()
    };
  }

}

class QuestionData {
  final String question;
  final String type;
  final String label;
  final List<String>? options;
  final dynamic selectedOptions;
  final String? answer;

  QuestionData({
    required this.question,
    required this.type,
    required this.label,
    this.options,
    this.selectedOptions,
    this.answer,
  });
}