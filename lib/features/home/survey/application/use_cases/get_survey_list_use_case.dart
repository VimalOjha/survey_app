import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';
import 'package:survey_app/features/home/survey/domain/survey_form_repository.dart';

class GetSurveyListUseCase {
  final SurveyFormRepository  surveyFormRepository;
  GetSurveyListUseCase({required this.surveyFormRepository});
  final int itemsPerPage = 10;

  Future<List<SurveyForm>> getSurveyList() async {
    return await surveyFormRepository.loadSurveyForms([], itemsPerPage);
  }

}