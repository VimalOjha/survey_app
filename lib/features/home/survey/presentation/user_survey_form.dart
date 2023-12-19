import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/configs/utilities/common/presentation/widgets/custom_scorll_physics.dart';
import 'package:survey_app/configs/utilities/common/presentation/widgets/custom_snackbar.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/features/home/survey/application/survey_form_bloc.dart';
import 'package:survey_app/features/home/survey/application/survey_form_events.dart';
import 'package:survey_app/features/home/survey/application/survey_form_state.dart';
import 'package:survey_app/features/home/survey/domain/models/question.dart';
import 'package:survey_app/features/home/survey/domain/models/user_answer_model.dart';


class SurveyFormScreen extends StatefulWidget {
  final List<Question> questions;
  final String title;
  final String formId;
  const SurveyFormScreen({super.key, required this.formId, required this.title, required this.questions});

  @override
  _SurveyFormScreenState createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  Map<String,dynamic> dynamicUserInputMap = {};
  List<String> selectedMultiOptions = [];
  String selectedSingleChoice ='';
  var textAnswerEditController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    textAnswerEditController.dispose();
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool isValid(){
    CustomSnackbar snackbar = CustomSnackbar(context);
    if (widget.questions[currentIndex].isTypeText())
    {
      if(textAnswerEditController.text.trim().isEmpty){
        snackbar.show(message: AppStrings.labelErrorEnterYourAnswer);
        return false;
      }
    }

    if (widget.questions[currentIndex].isTypeRadio()){
      if(selectedSingleChoice.isEmpty){
        snackbar.show(message: AppStrings.labelErrorSelectOption);
        return false;
      }
    }

    if (widget.questions[currentIndex].isTypeMultiSelect()){
      if(selectedMultiOptions.isEmpty){
        snackbar.show(message: AppStrings.labelErrorSelectOption);
        return false;
      }
    }
    return true;
  }

  void setDefaultValues(int index){
    if (dynamicUserInputMap.containsKey('text_answer_$index')) {
      textAnswerEditController =
      dynamicUserInputMap['text_answer_$index'];
    } else {
      textAnswerEditController = TextEditingController();
    }
    if (dynamicUserInputMap
        .containsKey('radio_answer_$index')) {
      selectedSingleChoice =
      dynamicUserInputMap['radio_answer_$index'];
    } else {
      selectedSingleChoice = '';
    }
    if (dynamicUserInputMap
        .containsKey('multichoice_answer_$index')) {
      setState(() {
        selectedMultiOptions = dynamicUserInputMap['multichoice_answer_$index'];
      });
    } else {
      selectedMultiOptions = [];
    }
  }

  void saveUserInputs() async {
    if (widget.questions[currentIndex].isTypeText()) {
      dynamicUserInputMap['text_answer_$currentIndex'] = textAnswerEditController;
    }

    if (widget.questions[currentIndex].isTypeRadio()) {
      dynamicUserInputMap['radio_answer_$currentIndex'] = selectedSingleChoice;
    }

    if (widget.questions[currentIndex].isTypeMultiSelect()) {
      dynamicUserInputMap['multichoice_answer_$currentIndex'] = selectedMultiOptions;
    }
  }

  void _submitForm() async {
    Map<String, dynamic> formData =
    UserAnswerModel(title: widget.title, questions: widget.questions).toUserSubmitJson(dynamicUserInputMap);
    BlocProvider.of<SurveyFormBloc>(context).add(SaveUserSurveyInput(widget.formId, formData));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyFormBloc, SurveyFormState>(
        listener: (context, state) {
          if(state is UserSurveyInputUploaded){
            BlocProvider.of<SurveyFormBloc>(context).add(ChangeFormStatus(widget.formId, AppStrings.labelSubmitted));
            Navigator.of(context).pop();
          }

          if(state is SurveyFormFetchFailure){
            CustomSnackbar snackbar = CustomSnackbar(context);
            snackbar.show(message: AppStrings.labelFailedToSubmitForm);
          }
        },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: BlocBuilder<SurveyFormBloc, SurveyFormState> (
          builder: (context, state){
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: widget.questions.length,
                    controller: _pageController,
                    physics: const CustomPageScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                        allowScroll: false),
                    onPageChanged: (int index) {
                      if (index > currentIndex) {
                        if (!isValid()) {
                          _pageController.animateToPage(index - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        } else {
                          saveUserInputs();
                          setDefaultValues(index);
                          setState(() {
                            currentIndex = index;
                          });
                        }
                      } else {
                        setDefaultValues(index);
                        setState(() {
                          currentIndex = index;
                        });
                      }
                    },
                    itemBuilder: (context, index) {
                      return Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.all(30),
                          width: double.maxFinite,
                          child: Column(children: [
                            if (widget.questions[index].isTypeText())
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(widget.questions[index].questionText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 24),
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 30),
                                  TextField(
                                    decoration: InputDecoration(
                                        labelText: AppStrings.labelWriteYourAnswer,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontWeight: FontWeight.normal)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    focusNode: _focusNode,
                                    controller: textAnswerEditController,
                                  ),
                                ],
                              ),
                            if (widget.questions[index].isTypeRadio())
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(widget.questions[index].questionText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 24),
                                        textAlign: TextAlign.center),
                                    const SizedBox(height: 30),
                                    Column(
                                      children: widget.questions[index].options!
                                          .map((option) {
                                        return RadioListTile(
                                          title: Text(option),
                                          value: option,
                                          groupValue: selectedSingleChoice,
                                          // Add logic for radio questions,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedSingleChoice = value!;
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ]),
                            if (widget.questions[index].isTypeMultiSelect())
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(widget.questions[index].questionText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 24),
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 30),
                                  Column(
                                    children: widget.questions[index].options!
                                        .map((option) {
                                      return CheckboxListTile(
                                        title: Text(option),
                                        value:
                                        selectedMultiOptions.contains(option),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value != null && value) {
                                              selectedMultiOptions.add(option);
                                            } else {
                                              selectedMultiOptions.remove(option);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  // Add similar logic for other question types
                                ],
                              ),
                          ]));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: currentIndex <= 0
                            ? null
                            : () {
                          _focusNode.unfocus();
                          setState(() {
                            currentIndex--;
                          });
                          _pageController.animateToPage(currentIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                        child: Text(
                          AppStrings.labelPrevious,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Question ${currentIndex + 1} of ${widget.questions.length}',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      if (currentIndex <= widget.questions.length - 1)
                        ElevatedButton(
                          onPressed: () {
                            _focusNode.unfocus();
                            if (currentIndex == widget.questions.length - 1) {
                              if (!isValid()) {
                                return;
                              }
                              saveUserInputs();
                              _submitForm();
                            } else {
                              if (!isValid()) {
                                return;
                              }
                              saveUserInputs();
                              setState(() {
                                currentIndex++;
                              });
                              _pageController.animateToPage(currentIndex,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            }
                          },
                          child: (state is UserInputUploading)
                              ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                              : Text(
                            currentIndex < widget.questions.length - 1
                                ? AppStrings.labelNext
                                : AppStrings.labelSubmit,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                              color:
                              Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
        }),
      ),
    );
  }
}


