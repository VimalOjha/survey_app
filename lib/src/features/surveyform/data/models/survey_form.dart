
import 'package:survey_app/src/features/surveyform/data/models/question.dart';
import 'package:survey_app/src/utils/commons/constants/enums/survey_status.dart';

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