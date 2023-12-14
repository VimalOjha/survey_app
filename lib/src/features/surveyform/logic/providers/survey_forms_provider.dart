import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/src/features/surveyform/data/models/question.dart';
import 'package:survey_app/src/features/surveyform/data/models/survey_config.dart';
import 'package:survey_app/src/features/surveyform/data/models/survey_form.dart';
import 'package:survey_app/src/features/surveyform/data/repositories/survey_form_repository.dart';

class SurveyDataProvider extends ChangeNotifier{
  final SurveyFormRepository surveyFormRepository;
  SurveyDataProvider(this.surveyFormRepository);
  bool isLoadingData = true;
  bool isFetchingFormStatus = false;
  bool isUploadingForm = false;
  bool? isFormSuccessfullyUploaded;
  List<SurveyForm>? _surveyList;
  List<SurveyForm>? _currentSurveyList;
  List<DocumentSnapshot>? currentItemList = [];
  String? formStatus;
  List<SurveyForm>? get surveyList => _surveyList;
  Map<String, dynamic>? formConfigData;
  List<SurveyConfigModel> questions = [];
  SurveyForm? newAddedSurveyForm;
  final int itemsPerPage = 10;
  bool hasMore = true;


  void getSurveyList() async {
    _surveyList = await surveyFormRepository.loadSurveyForms(currentItemList!, itemsPerPage);
    isLoadingData = false;
    notifyListeners();
  }

  void getSurveyFormStatus(String formId) async {
    isFetchingFormStatus = true;
    formStatus = await surveyFormRepository.getFormStatus(formId);
    isFetchingFormStatus = false;
    notifyListeners();
  }

  void setSurveyFormStatus(String formId, String newStatus){
    for (var form in surveyList!) {
      if (form.id == formId) {
        form.formStatus = newStatus;
        break;
      }
    }
    notifyListeners();
  }

  Future<SurveyForm?> addNewSurveyForm(String title , List<Question> questions) async{
    isUploadingForm = true;
    notifyListeners();
    try {
      newAddedSurveyForm = await surveyFormRepository.addSurveyForm(title, questions);
      isUploadingForm = false;
    } on Exception catch (e) {
      isUploadingForm = false;
    }

    return newAddedSurveyForm;
  }

  void loadSurveyConfig() async {
    isLoadingData = true;
    List<dynamic>? questionsData  = await surveyFormRepository.loadFormConfigData();
    if(questionsData != null && questionsData!.isNotEmpty){
      questions = questionsData.map((question) {
        return SurveyConfigModel.fromJson(question);
      }).toList();
    }
    isLoadingData = false;
    notifyListeners();
  }

  void addNewFormToList(SurveyForm surveyForm) {
    surveyList?.insert(0, surveyForm);
    notifyListeners();
  }

  Future<bool> saveUserFormInputs(
      String formId, Map<String, dynamic> formData) async {
    bool isSaved = false;
    isUploadingForm = true;
    notifyListeners();
    isSaved = await surveyFormRepository.submitUserInput(formId, formData);
    isUploadingForm = false;
    notifyListeners();

    return isSaved;
  }
}