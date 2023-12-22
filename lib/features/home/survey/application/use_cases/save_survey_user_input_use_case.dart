import 'package:survey_app/features/home/survey/domain/survey_form_repository.dart';

class SaveSurveyUserInputUseCase {
  final SurveyFormRepository  surveyFormRepository;
  SaveSurveyUserInputUseCase({required this.surveyFormRepository});
  final int itemsPerPage = 10;

  Future<bool> saveUserFormInputs(
      String formId, Map<String, dynamic> formData) async {
    bool isSaved = false;
    isSaved = await surveyFormRepository.submitUserInput(formId, formData);

    return isSaved;
  }
}