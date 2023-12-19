import 'package:equatable/equatable.dart';
import 'package:survey_app/features/home/survey/domain/models/question.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';


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
  final String title;
  final List<Question> question;
  SaveNewSurveyForm(this.title, this.question);

  @override
  List<Object?> get props => [];
}

class FetchSurveyConfig extends SurveyFormEvent{
  @override
  List<Object?> get props => [];
}

class SaveUserSurveyInput extends SurveyFormEvent{
  final String formId;
  final Map<String, dynamic> formData;

  SaveUserSurveyInput(this.formId, this.formData);
  @override
  List<Object?> get props => [];
}


