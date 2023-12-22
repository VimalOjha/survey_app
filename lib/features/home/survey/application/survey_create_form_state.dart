
import 'package:survey_app/configs/utilities/constants/enums/data_state_enum.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_config.dart';

class CreateSurveyFormState {
  final DataState dataState;
  final String errorMessage;
  List<SurveyConfigModel>? configList = [];

  CreateSurveyFormState({
    this.dataState = DataState.none,
    this.errorMessage = '',
    this.configList,
  });

  CreateSurveyFormState copyWith({
    DataState? dataState,
    String? errorMessage,
    List<SurveyConfigModel>? configList,
  }) {
    return CreateSurveyFormState(
      dataState: dataState ?? this.dataState,
      errorMessage: errorMessage ?? this.errorMessage,
      configList: configList ?? this.configList,
    );
  }
}
