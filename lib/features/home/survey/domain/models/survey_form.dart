

import 'package:survey_app/configs/utilities/constants/enums/survey_status.dart';
import 'package:survey_app/features/home/survey/domain/models/question.dart';

class SurveyForm{
  final String id;
  final String title;
  final List<Question> questions;
  final bool isLoading;
  String? formStatus;

  SurveyForm({required this.id, required this.title, required this.questions, this.isLoading = true, this.formStatus });


  bool isSubmitted() {
    return formStatus == SurveyStatus.SUBMITTED.name;
  }

  bool isPending() {
    return formStatus == SurveyStatus.PENDING.name;
  }
}