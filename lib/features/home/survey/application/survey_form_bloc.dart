
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/features/home/survey/application/survey_form_events.dart';
import 'package:survey_app/features/home/survey/application/survey_form_state.dart';
import 'package:survey_app/features/home/survey/application/use_cases/survey_use_cases.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';


class SurveyFormBloc extends Bloc<SurveyFormEvent, SurveyFormState>{
  final SurveyUseCases surveyUseCases;
  List<SurveyForm> surveyList = [];

  SurveyFormBloc(this.surveyUseCases) : super(SurveyFormsInitial()){
    on<FetchSurveyForms>(_onFetchSurveyForm);
    on<ChangeFormStatus>(_onChangeFormStatus);
    on<NewSurveyAdded>(_onNewFormAdded);
    on<SaveNewSurveyForm>(_onSaveNewForm);
    on<FetchSurveyConfig>(_onFetchSurveyConfig);
    on<SaveUserSurveyInput>(_onSaveUserInputForm);
  }

  void _onFetchSurveyForm(FetchSurveyForms event, Emitter<SurveyFormState> emitter) async{
    emitter(SurveyFormLoading());
    try {
      surveyList = await surveyUseCases.getSurveyList();
      emitter(SurveyFormFetched(surveyList));
    } catch (error) {
      emitter(SurveyFormFetchFailure(error: error.toString()));
    }
  }

  void _onChangeFormStatus(ChangeFormStatus event, Emitter<SurveyFormState> emitter){
     // SurveyFormsStatusChanged(newStatus: event.newStatus));
    emitter(SurveyFormLoading());
    try {
      for (var form in surveyList) {
        if (form.id == event.formId) {
          form.formStatus = event.newStatus;
          break;
        }
      }
      emitter(SurveyFormFetched(surveyList));
    } catch (error) {
      emitter(SurveyFormFetchFailure(error: error.toString()));
    }
   }

  void _onNewFormAdded(NewSurveyAdded event, Emitter<SurveyFormState> emitter){
    if (surveyList.isEmpty) {
      surveyList.add(event.surveyForm); // If the list is empty, simply add the form
    } else {
      surveyList.insert(0, event.surveyForm); // If not empty, insert at index 0
    }
    emitter(SurveyFormFetched(surveyList));
  }

  void _onSaveNewForm(SaveNewSurveyForm event, Emitter<SurveyFormState> emitter) async {
    emitter(SurveyFormLoading());
    try{
      SurveyForm? form = await surveyUseCases.addNewSurveyForm(event.title, event.question);
      if(form != null) {
        if (surveyList.isEmpty) {
          surveyList.add(form); // If the list is empty, simply add the form
        } else {
          surveyList.insert(0, form); // If not empty, insert at index 0
        }
        emitter(SurveyFormFetched(surveyList));
      } else {
        emitter(SurveyFormFetchFailure(error: "Something went wrong!!"));
      }
    } catch (error){
      emitter(SurveyFormFetchFailure(error: error.toString()));
    }
  }

  void _onFetchSurveyConfig(FetchSurveyConfig event, Emitter<SurveyFormState> emitter) async {
    emitter(SurveyConfigFormLoading());
    try{
      final list = await surveyUseCases.loadSurveyConfig();
      emitter(FetchedSurveyConfig(list: list));
    }catch (error){
      emitter(SurveyFormFetchFailure(error: error.toString()));
    }
  }

  void _onSaveUserInputForm (SaveUserSurveyInput event, Emitter<SurveyFormState> emitter) async{
    emitter(UserInputUploading());
    try {
      final isUploaded = await surveyUseCases.saveUserFormInputs(event.formId, event.formData);
      if(isUploaded) {
        emitter(UserSurveyInputUploaded());
      }else{
        emitter(SurveyFormFetchFailure(error: "Something went wrong! please try again."));
      }
    } catch (error) {
      emitter(SurveyFormFetchFailure(error: error.toString()));
    }
  }
}