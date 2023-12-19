
import 'package:survey_app/features/home/survey/domain/models/question.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_config.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';
import 'package:survey_app/features/home/survey/domain/survey_form_repository.dart';

class SurveyUseCases {
  final SurveyFormRepository  surveyFormRepository;
  SurveyUseCases(this.surveyFormRepository);
  final int itemsPerPage = 10;

  Future<List<SurveyForm>> getSurveyList() async {
    return await surveyFormRepository.loadSurveyForms([], itemsPerPage);
  }


  void setSurveyFormStatus(String formId, String newStatus, List<SurveyForm> list){
    for (var form in list) {
      if (form.id == formId) {
        form.formStatus = newStatus;
        break;
      }
    }
  }

  Future<SurveyForm?> addNewSurveyForm(String title , List<Question> questions) async{
    try {
       return await surveyFormRepository.addSurveyForm(title, questions);
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<List<SurveyConfigModel>> loadSurveyConfig() async {
    List<dynamic>? questionsData  = await surveyFormRepository.loadFormConfigData();
    if(questionsData != null && questionsData!.isNotEmpty){
      return questionsData.map((question) {
        return SurveyConfigModel.fromJson(question);
      }).toList();
    }
    return [];
  }


  Future<bool> saveUserFormInputs(
      String formId, Map<String, dynamic> formData) async {
    bool isSaved = false;
    isSaved = await surveyFormRepository.submitUserInput(formId, formData);

    return isSaved;
  }
}