
import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form_create_request.dart';
import 'package:survey_app/features/home/survey/domain/survey_form_repository.dart';

class AddNewSurveyUseCase {
  final SurveyFormRepository  surveyFormRepository;
  AddNewSurveyUseCase({required this.surveyFormRepository});
  final int itemsPerPage = 10;

  Future<SurveyForm?> addNewSurveyForm(SurveyFormCreateRequest request) async{
    try {
      return await surveyFormRepository.addSurveyForm(request);
    } on Exception {
      rethrow;
    }
  }
}