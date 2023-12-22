import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/configs/utilities/common/presentation/widgets/custom_snackbar.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/configs/utilities/constants/enums/survey_create_form_state.dart';
import 'package:survey_app/features/home/survey/application/survey_form_bloc.dart';
import 'package:survey_app/features/home/survey/application/survey_form_events.dart';
import 'package:survey_app/features/home/survey/application/survey_form_state.dart';
import 'package:survey_app/features/home/survey/domain/models/question.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_config.dart';
import 'package:survey_app/features/home/survey/presentation/widgets/form_card_type_choice_widget.dart';
import 'package:survey_app/features/home/survey/presentation/widgets/form_card_type_text_widget.dart';
import 'package:survey_app/features/home/survey/presentation/widgets/form_text_field_widget.dart';

class NewForm extends StatefulWidget {
  const NewForm({super.key, required this.saveForm});
  final void Function(String title, List<Question> questions) saveForm;
  @override
  State<NewForm> createState() {
    return _NewFormState();
  }
}

class _NewFormState extends State<NewForm> {
  Map<String,dynamic> dynamicQuestionMap = {};
  late SurveyFormBloc surveyFormBloc;
  final _titleController = TextEditingController();
  final List<TextEditingController> _questionTextFieldController = [];
  final List<TextEditingController> _questionInstructionTextFieldController = [];
  final List<TextEditingController> _optionsTextFieldController = [];

  void _submit(List<SurveyConfigModel> configList){
    bool hasEmptyQuestions = false;
    bool hasEmptyOptions = false;

    if(_titleController.text.trim().isEmpty){
      CustomSnackbar(context).show(message: AppStrings.labelErrorEnterTitle);
      return;
    }
    for(var i =0; i<_questionTextFieldController.length; i++){
      if(_questionTextFieldController[i].text.trim().isEmpty){
        hasEmptyQuestions = true;
        break;
      }
    }

    for(var i =0; i<_optionsTextFieldController.length; i++){
      if(_optionsTextFieldController[i].text.trim().isEmpty){
        hasEmptyOptions = true;
        break;
      }
    }

    if(hasEmptyQuestions){
      CustomSnackbar(context).show(message: AppStrings.labelErrorEnterQuestion);
      return;
    }

    if(hasEmptyOptions){
      CustomSnackbar(context).show(message: AppStrings.labelErrorEnterOptions);
      return;
    }

    List<Question> dynamicQuestionsList = [];

    for (var j =0; j< configList.length;j++) {
      final index = j;
      final question = configList[j];
      dynamicQuestionsList.add(question.createJsonForm(question, dynamicQuestionMap, index));
    }

    widget.saveForm(_titleController.text.trim(), dynamicQuestionsList);
  }

  @override
  void initState() {
    super.initState();
    surveyFormBloc = context.read();
    surveyFormBloc.add(FetchSurveyConfig());
  }

  @override
  void dispose() {
    _titleController.dispose();
    for(var i=0;i<_questionTextFieldController.length;i++){
      _questionTextFieldController[i].dispose();
    }
    for(var i=0;i<_questionInstructionTextFieldController.length;i++){
      _questionInstructionTextFieldController[i].dispose();
    }

    for(var i=0;i<_optionsTextFieldController.length;i++){
      _optionsTextFieldController[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamicQuestionMap.clear();
    _questionTextFieldController.clear();
    _questionInstructionTextFieldController.clear();
    _optionsTextFieldController.clear();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormTextFieldWidget(
                labelText: AppStrings.labelEnterTitle,
                controller: _titleController,
              ),
            ),
          ),
          BlocBuilder<SurveyFormBloc, SurveyFormState>(
              builder:(ctx, state){
                  if(state.surveyCreateFormStatus == SurveyCreateFormStatus.configLoading){
                    return const CircularProgressIndicator();
                  } else if(state.surveyCreateFormStatus == SurveyCreateFormStatus.configLoaded && state.configList!.isNotEmpty){

                    return Column(
                      children: state.configList!
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final question = entry.value;

                        if (question.isTypeText()) {

                          final textQuestionEditController = TextEditingController();
                          final textQuestionInstructionEditController = TextEditingController();
                          _questionTextFieldController.add(textQuestionEditController);
                          _questionInstructionTextFieldController.add(textQuestionInstructionEditController);
                          dynamicQuestionMap["type_$index"] = question.type;
                          dynamicQuestionMap["question_controller_$index"] = textQuestionEditController;
                          dynamicQuestionMap["question_label_controller_$index"] = textQuestionInstructionEditController;
                          return Column(
                            children: [
                              const SizedBox(height: 16,),
                              FormCardTypeTextWidget(
                                  controllerQuestion: textQuestionEditController,
                                  controllerInstruction: textQuestionInstructionEditController,
                                  index: index),
                            ],
                          );
                        }

                        if (question.isTypeRadio()) {
                          final List<TextEditingController> optionsList =[];
                          final textQuestionEditController = TextEditingController();

                          _questionTextFieldController.add(textQuestionEditController);

                          for(var i=0; i<question.optionsCount; i++){
                            final textRadioOptionsEditController = TextEditingController();
                            _optionsTextFieldController.add(textRadioOptionsEditController);
                            optionsList.add(textRadioOptionsEditController);

                          }
                          dynamicQuestionMap["type_$index"] = question.type;
                          dynamicQuestionMap["question_controller_$index"] = textQuestionEditController;
                          dynamicQuestionMap["options_controller_$index"] = optionsList;
                          return Column(
                            children: [
                              const SizedBox(height: 16,),
                              FormCardTypeChoiceWidget(
                                  labelText: AppStrings.labelSingleChoiceQuestion,
                                  controller: textQuestionEditController,
                                  index: index,
                                  optionsList: optionsList),
                            ],
                          );
                        }

                        if (question.isTypeMultiSelect()) {
                          final List<TextEditingController> optionsList =[];
                          final textQuestionEditController = TextEditingController();
                          _questionTextFieldController.add(textQuestionEditController);


                          for(var i=0; i<question.optionsCount; i++){
                            final textOptionsEditController = TextEditingController();
                            _optionsTextFieldController.add(textOptionsEditController);
                            optionsList.add(textOptionsEditController);
                          }

                          dynamicQuestionMap["type_$index"] = question.type;
                          dynamicQuestionMap["question_controller_$index"] = textQuestionEditController;
                          dynamicQuestionMap["options_controller_$index"] = optionsList;

                          return Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              FormCardTypeChoiceWidget(
                                  labelText: AppStrings.labelMultiChoiceOption,
                                  controller: textQuestionEditController,
                                  index: index,
                                  optionsList: optionsList
                              ),
                            ],
                          );
                        }

                      })
                          .map((widget) => Column(children: [widget!]))
                          .toList(),
                    );

                  }
                    return const Text(AppStrings.labelSomethingWentWrong);
              }
          ),

          BlocBuilder<SurveyFormBloc, SurveyFormState>(
              builder:(ctx, state) {
                if(state.surveyCreateFormStatus == SurveyCreateFormStatus.configLoaded && state.configList!.isNotEmpty){
                  return Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      ElevatedButton(
                        onPressed: state.configList!.isEmpty ? null : (){_submit(state.configList!);},
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer),
                        child: Text(
                          AppStrings.labelSubmit,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  );
                }
                return const SizedBox.shrink();
              }
          ),
        ],
      ),
    );
  }
}
