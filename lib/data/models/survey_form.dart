
import 'package:survey_app/data/models/question.dart';

class SurveyForm{
  final String id;
  final String title;
  final List<Question> questions;

  SurveyForm({required this.id, required this.title, required this.questions });
}