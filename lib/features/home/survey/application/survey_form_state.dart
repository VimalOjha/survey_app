
import 'package:equatable/equatable.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_config.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';

abstract class SurveyFormState extends Equatable{

}
class SurveyFormsInitial extends SurveyFormState{
  @override
  List<Object?> get props => [];
}
class SurveyFormLoading extends SurveyFormState{
  @override
  List<Object?> get props => [];
}

class SurveyFormFetched extends SurveyFormState{
  final List<SurveyForm> surveyFormsList;

  SurveyFormFetched(this.surveyFormsList);
  @override
  List<Object?> get props => [];

}

class SurveyFormFetchFailure extends SurveyFormState {
  final String error;

  SurveyFormFetchFailure({required this.error});
  @override
  List<Object?> get props => [];
}

class SurveyFormsStatusChanged extends SurveyFormState{
  final String newStatus;
  SurveyFormsStatusChanged({required this.newStatus});
  @override
  List<Object?> get props => [];
}

class SurveyConfigFormLoading extends SurveyFormState{
  @override
  List<Object?> get props => [];
}


class UserInputUploading extends SurveyFormState{
  @override
  List<Object?> get props => [];
}

class UserSurveyInputUploaded extends SurveyFormState{
  @override
  List<Object?> get props => [];
}

class FetchedSurveyConfig extends SurveyFormState{
  final List<SurveyConfigModel> list;

  FetchedSurveyConfig({required this.list});

  @override
  List<Object?> get props => [];
}
