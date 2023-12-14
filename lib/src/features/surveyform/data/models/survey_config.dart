import 'package:flutter/material.dart';
import 'package:survey_app/src/features/surveyform/data/models/question.dart';
import 'package:survey_app/src/utils/commons/constants/enums/questions_enum.dart';

class SurveyConfigModel {

  final String type;
  final int optionsCount;


  SurveyConfigModel({required this.type, this.optionsCount = 2});

  factory SurveyConfigModel.fromJson(Map<String, dynamic> json) {
    return SurveyConfigModel(
      type: json['type'] as String,
      optionsCount: json.containsKey('optionsCount') ? json['optionsCount'] as int : 2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'optionsCount': optionsCount,
    };
  }

  bool isTypeText(){
    return type == Questions.text.name;
  }

  bool isTypeRadio(){
    return type == Questions.radio.name;
  }

  bool isTypeMultiSelect(){
    return type == Questions.multiselect.name;
  }


  Question createJsonForm(SurveyConfigModel question, Map<String, dynamic> dynamicQuestionMap, int index){
    Question? dynamicQuestion;
    if (question.isTypeText()) {
      final textController = dynamicQuestionMap['question_controller_$index'] as TextEditingController;
      final labelTextController = dynamicQuestionMap["question_label_controller_$index"] as TextEditingController;
      dynamicQuestion = Question(
        questionText: textController.text.trim(),
        type: question.type,
        questionLabel: labelTextController.text.trim(),
      );
    }

    if (question.isTypeRadio()) {
      final textController = dynamicQuestionMap['question_controller_$index'] as TextEditingController;
      final optionsList = dynamicQuestionMap["options_controller_$index"] as List<TextEditingController>;
      List<String> dynamicRadioOptions=[];
      for(final radioOption in optionsList){
        dynamicRadioOptions.add(radioOption.text.trim());
      }
      dynamicQuestion = Question(
          questionText: textController.text.trim(),
          type: question.type,
          options: dynamicRadioOptions
      );
    }
    if (question.isTypeMultiSelect()) {
      final textController = dynamicQuestionMap['question_controller_$index'] as TextEditingController;
      final optionsList = dynamicQuestionMap["options_controller_$index"] as List<TextEditingController>;
      List<String> dynamicChoiceOptions=[];
      for(final choiceOption in optionsList){
        dynamicChoiceOptions.add(choiceOption.text.trim());
      }
      dynamicQuestion = Question(
          questionText: textController.text.trim(),
          type: question.type,
          options: dynamicChoiceOptions
      );
    }



    return dynamicQuestion!;
  }

}