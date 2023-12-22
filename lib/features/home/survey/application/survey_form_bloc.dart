
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/configs/utilities/constants/enums/data_state_enum.dart';
import 'package:survey_app/configs/utilities/constants/enums/survey_create_form_state.dart';
import 'package:survey_app/features/home/survey/application/survey_form_events.dart';
import 'package:survey_app/features/home/survey/application/survey_form_state.dart';
import 'package:survey_app/features/home/survey/application/use_cases/add_new_survey_use_case.dart';
import 'package:survey_app/features/home/survey/application/use_cases/get_survey_list_use_case.dart';
import 'package:survey_app/features/home/survey/application/use_cases/load_survey_config_use_case.dart';
import 'package:survey_app/features/home/survey/application/use_cases/save_survey_user_input_use_case.dart';
import 'package:survey_app/features/home/survey/application/use_cases/set_survey_status_use_case.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';


class SurveyFormBloc extends Bloc<SurveyFormEvent, SurveyFormState>{
  final GetSurveyListUseCase getSurveyListUseCases;
  final AddNewSurveyUseCase addNewSurveyUseCase;
  final LoadSurveyConfigUseCase loadSurveyConfigUseCase;
  final SaveSurveyUserInputUseCase saveUserSurveyInput;
  final SetSurveyStatusUseCase setSurveyStatusUseCase;
  List<SurveyForm> surveyList = [];

  SurveyFormBloc({
    required this.getSurveyListUseCases,
    required this.addNewSurveyUseCase,
    required this.loadSurveyConfigUseCase,
    required this.saveUserSurveyInput,
    required this.setSurveyStatusUseCase
  }) : super(SurveyFormState()){
    on<FetchSurveyForms>(_onFetchSurveyForm);
    on<SaveNewSurveyForm>(_onSaveNewForm);
    on<FetchSurveyConfig>(_onFetchSurveyConfig);
    on<SaveUserSurveyInput>(_onSaveUserInputForm);
  }

  FutureOr<void> _onFetchSurveyForm(FetchSurveyForms event, Emitter<SurveyFormState> emit) async{
    emit(state.copyWith(dataState: DataState.loading));
    try {
      final surveyList = await getSurveyListUseCases.getSurveyList();
      emit(state.copyWith(surveyFormsList: surveyList));
      emit(state.copyWith(dataState: DataState.loaded));
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), dataState: DataState.error));
    }
  }

  FutureOr<void> _onSaveNewForm(SaveNewSurveyForm event, Emitter<SurveyFormState> emit) async{
    emit(state.copyWith(surveyCreateFormStatus: SurveyCreateFormStatus.uploading));
    try{
      SurveyForm? form = await addNewSurveyUseCase.addNewSurveyForm(event.createRequest);
      if(form != null) {
        state.surveyFormsList ??= [];
        if (state.surveyFormsList!.isEmpty) {
          state.surveyFormsList!.add(form); // If the list is empty, simply add the form
        } else {
          state.surveyFormsList!.insert(0, form); // If not empty, insert at index 0
        }
        emit(state.copyWith(surveyCreateFormStatus: SurveyCreateFormStatus.completed));
      } else {
        emit(state.copyWith(errorMessage: "Something went wrong!!", dataState: DataState.error));
      }
    } catch (error){
      emit(state.copyWith(errorMessage: error.toString(), dataState: DataState.error));
    }
  }

  FutureOr<void> _onFetchSurveyConfig(FetchSurveyConfig event, Emitter<SurveyFormState> emit) async{
    emit(state.copyWith(surveyCreateFormStatus: SurveyCreateFormStatus.configLoading));
    try{
      final list = await loadSurveyConfigUseCase.loadSurveyConfig();
      emit(state.copyWith(configList: list));
      emit(state.copyWith(surveyCreateFormStatus: SurveyCreateFormStatus.configLoaded));
    }catch (error){
      emit(state.copyWith(errorMessage: error.toString(), dataState: DataState.error));
    }
  }

  FutureOr<void> _onSaveUserInputForm(SaveUserSurveyInput event, Emitter<SurveyFormState> emit) async{
    emit(state.copyWith(dataState: DataState.loading));
    try {
      final isUploaded = await saveUserSurveyInput.saveUserFormInputs(event.formId, event.formData);
      if(isUploaded) {
        state.surveyFormsList![event.index].formStatus = AppStrings.labelSubmitted;
        emit(state.copyWith(dataState: DataState.loaded));
      } else {
        emit(state.copyWith(errorMessage: "Something went wrong! please try again.", dataState: DataState.error));
      }
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), dataState: DataState.error));
    }
  }
}