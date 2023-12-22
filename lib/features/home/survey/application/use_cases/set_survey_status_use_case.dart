import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';
import 'package:survey_app/features/home/survey/domain/survey_form_repository.dart';

class SetSurveyStatusUseCase {
  final SurveyFormRepository  surveyFormRepository;
  SetSurveyStatusUseCase({required this.surveyFormRepository});
  final int itemsPerPage = 10;

  void setSurveyFormStatus(String formId, String newStatus, List<SurveyForm> list){
    for (var form in list) {
      if (form.id == formId) {
        form.formStatus = newStatus;
        break;
      }
    }
  }
}