import 'package:survey_app/configs/utilities/constants/enums/data_state_enum.dart';
import 'package:survey_app/configs/utilities/constants/enums/survey_create_form_state.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_config.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';


class SurveyFormState {
  final DataState dataState;
  final String errorMessage;
  final String newFormStatus;
  final SurveyCreateFormStatus surveyCreateFormStatus;
  List<SurveyForm>? surveyFormsList = [];
  List<SurveyConfigModel>? configList = [];

  SurveyFormState({
    this.dataState = DataState.none,
    this.errorMessage = '',
    this.newFormStatus = '',
    this.configList,
    this.surveyFormsList,
    this.surveyCreateFormStatus = SurveyCreateFormStatus.none
  });

  SurveyFormState copyWith({
    DataState? dataState,
    String? errorMessage,
    String? newFormStatus,
    SurveyCreateFormStatus? surveyCreateFormStatus,
    List<SurveyForm>? surveyFormsList,
    List<SurveyConfigModel>? configList,
  }) {
    return SurveyFormState(
      dataState: dataState ?? this.dataState,
      errorMessage: errorMessage ?? this.errorMessage,
      newFormStatus: newFormStatus ?? this.newFormStatus,
      surveyCreateFormStatus:
      surveyCreateFormStatus ?? this.surveyCreateFormStatus,
      surveyFormsList: surveyFormsList ?? this.surveyFormsList,
      configList: configList ?? this.configList,
    );
  }
}

