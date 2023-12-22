import 'package:survey_app/features/home/survey/domain/models/survey_config.dart';
import 'package:survey_app/features/home/survey/domain/survey_form_repository.dart';

class LoadSurveyConfigUseCase {
  final SurveyFormRepository  surveyFormRepository;
  LoadSurveyConfigUseCase({required this.surveyFormRepository});
  final int itemsPerPage = 10;

  Future<List<SurveyConfigModel>> loadSurveyConfig() async {
    List<dynamic>? questionsData  = await surveyFormRepository.loadFormConfigData();
    if(questionsData != null && questionsData.isNotEmpty){
      return questionsData.map((question) {
        return SurveyConfigModel.fromJson(question);
      }).toList();
    }
    return [];
  }

}