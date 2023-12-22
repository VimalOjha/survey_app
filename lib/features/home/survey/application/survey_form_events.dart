import 'package:equatable/equatable.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form_create_request.dart';


abstract class SurveyFormEvent extends Equatable {}

class SurveyFormsFetchedSuccess extends SurveyFormEvent{
  final List<SurveyForm> surveyForms;

  SurveyFormsFetchedSuccess(this.surveyForms);

  @override
  List<Object?> get props => [];
}
class FetchSurveyForms extends SurveyFormEvent{
  @override
  List<Object?> get props => [];
}

class SurveyFormsFetchedFailure extends SurveyFormEvent{

  @override
  List<Object?> get props => [];
}

class ChangeFormStatus extends SurveyFormEvent{
  final String newStatus;
  final String formId;
  ChangeFormStatus(this.formId, this.newStatus);

  @override
  List<Object?> get props => [];
}

class NewSurveyAdded extends SurveyFormEvent{
  final SurveyForm surveyForm;
  NewSurveyAdded(this.surveyForm);
  @override
  List<Object?> get props => [];
}

class SaveNewSurveyForm extends SurveyFormEvent{
  final SurveyFormCreateRequest createRequest;
  SaveNewSurveyForm({required this.createRequest});

  @override
  List<Object?> get props => [createRequest];
}

class FetchSurveyConfig extends SurveyFormEvent{
  @override
  List<Object?> get props => [];
}

class SaveUserSurveyInput extends SurveyFormEvent{
  final String formId;
  final Map<String, dynamic> formData;
  final int index;

  SaveUserSurveyInput(this.formId, this.formData, this.index);
  @override
  List<Object?> get props => [];
}


