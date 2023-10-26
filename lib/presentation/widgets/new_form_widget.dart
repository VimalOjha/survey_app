import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_app/data/models/question.dart';

class NewForm extends StatefulWidget {
  const NewForm({super.key, required this.saveForm});

  final void Function(String title, List<Question> questions) saveForm;

  @override
  State<NewForm> createState() {
    return _NewFormState();
  }
}

class _NewFormState extends State<NewForm> {
  List<dynamic> questions = [];
  Map<String,dynamic> dynamicQuestionMap = {};
  final _titleController = TextEditingController();
  final List<TextEditingController> _questionTextFieldController = [];
  final List<TextEditingController> _questionInstructionTextFieldController = [];
  final List<TextEditingController> _optionsTextFieldController = [];
  var showButton = false;
  Future<Map<String, dynamic>> loadFormData() async {
     String data = "";
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection("form_json_config").get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0].data() as Map<String, dynamic> ;
      }else{
        data = await rootBundle.loadString('assets/form_config.json');
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
       data = await rootBundle.loadString('assets/form_config.json');
    }
    //code to add json on firestore
    /*final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      try {
        await _firestore.collection('form_json_config').add(jsonDecode(data));
      } catch (e) {
        print('Error adding data to Firestore: $e');
    }*/
    return jsonDecode(data);
  }
  var isLoading = false;

  void _submit(){
    bool hasEmptyQuestions = false;
    bool hasEmptyOptions = false;

    if(_titleController.text.trim().isEmpty){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter Title!', style:
          TextStyle(
              color: Theme.of(context).colorScheme.error
          ),))
      );
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
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter All Questions ', style:
          TextStyle(
              color: Theme.of(context).colorScheme.error
          ),))
      );
      return;
    }

    if(hasEmptyOptions){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter All Options!}', style:
          TextStyle(
              color: Theme.of(context).colorScheme.error
          ),))
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    List<Question> dynamicQuestionsList = [];

    for (var j =0; j< questions.length;j++) {
      final index = j;
      final question = questions[j];

      if (question['type'] == 'text') {
        final textController = dynamicQuestionMap['question_controller_$index'] as TextEditingController;
        final labelTextController = dynamicQuestionMap["question_label_controller_$index"] as TextEditingController;
        final dynamicQuestion = Question(
          questionText: textController.text.trim(),
          type: 'text',
          questionLabel: labelTextController.text.trim(),
        );

        dynamicQuestionsList.add(dynamicQuestion);
      }

      if (question['type'] == 'radio') {
        final textController = dynamicQuestionMap['question_controller_$index'] as TextEditingController;
        final optionsList = dynamicQuestionMap["options_controller_$index"] as List<TextEditingController>;
        List<String> dynamicRadioOptions=[];
        for(final radioOption in optionsList){
          dynamicRadioOptions.add(radioOption.text.trim());
        }
        final dynamicQuestion = Question(
          questionText: textController.text.trim(),
          type: 'radio',
          options: dynamicRadioOptions
        );

        dynamicQuestionsList.add(dynamicQuestion);
      }
      if (question['type'] == 'multiselect') {
        final textController = dynamicQuestionMap['question_controller_$index'] as TextEditingController;
        final optionsList = dynamicQuestionMap["options_controller_$index"] as List<TextEditingController>;
        List<String> dynamicChoiceOptions=[];
        for(final choiceOption in optionsList){
          dynamicChoiceOptions.add(choiceOption.text.trim());
        }
        final dynamicQuestion = Question(
            questionText: textController.text.trim(),
            type: 'multiselect',
            options: dynamicChoiceOptions
        );

        dynamicQuestionsList.add(dynamicQuestion);
      }

    }
    setState(() {
      isLoading = false;
    });
    widget.saveForm(_titleController.text.trim(), dynamicQuestionsList);
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
              child: TextField(
                decoration:  InputDecoration(
                  labelText: 'Enter Title',
                    labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.normal
                    )
                ),
                keyboardType: TextInputType.text,
                maxLength: 30,
                autocorrect: false,
                  controller: _titleController,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                  )
              ),
            ),
          ),
          FutureBuilder<Map<String, dynamic>>(
              future: loadFormData(),
              builder: (ctx, state) {
                if (state.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (state.connectionState == ConnectionState.done && state.hasData) {
                  final formData = state.data!;
                  questions = formData['questions'];

                  return Column(
                    children: questions
                        .asMap()
                        .entries
                        .map((entry) {
                          final index = entry.key;
                          final question = entry.value;

                          if (question['type'] == 'text') {

                            final textQuestionEditController = TextEditingController();
                            final textQuestionInstructionEditController = TextEditingController();
                            _questionTextFieldController.add(textQuestionEditController);
                            _questionInstructionTextFieldController.add(textQuestionInstructionEditController);
                            dynamicQuestionMap["type_$index"] = 'text';
                            dynamicQuestionMap["question_controller_$index"] = textQuestionEditController;
                            dynamicQuestionMap["question_label_controller_$index"] = textQuestionInstructionEditController;
                            return Column(
                              children: [
                                const SizedBox(height: 16,),
                                Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Enter your question ${index + 1}',
                                            labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                              color: Theme.of(context).colorScheme.onBackground,
                                              fontWeight: FontWeight.normal
                                            )
                                          ),
                                          controller: textQuestionEditController,
                                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                  color: Theme.of(context).colorScheme.onBackground,
                                                ),
                                        ),

                                        const SizedBox(
                                          height: 12,
                                        ),
                                         TextField(
                                          decoration:  InputDecoration(
                                              labelText:
                                                  'Enter your instruction for your question',
                                            labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                color: Theme.of(context).colorScheme.onBackground,
                                                fontWeight: FontWeight.normal
                                            )
                                          ),
                                          controller: textQuestionInstructionEditController,
                                             style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                 color: Theme.of(context).colorScheme.onBackground,
                                                 fontWeight: FontWeight.normal
                                             )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          if (question['type'] == 'radio') {
                            final List<TextEditingController> optionsList =[];
                            final textQuestionEditController = TextEditingController();

                            _questionTextFieldController.add(textQuestionEditController);

                            final optionsCount = question['options_count'] ?? 2;
                            for(var i=0; i<optionsCount;i++){
                              final textRadioOptionsEditController = TextEditingController();
                              _optionsTextFieldController.add(textRadioOptionsEditController);
                              optionsList.add(textRadioOptionsEditController);

                            }
                            dynamicQuestionMap["type_$index"] = 'radio';
                            dynamicQuestionMap["question_controller_$index"] = textQuestionEditController;
                            dynamicQuestionMap["options_controller_$index"] = optionsList;
                            return Column(
                              children: [
                                const SizedBox(height: 16,),
                                Card(
                                  margin: const EdgeInsets.all(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('*Single choice question'),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Enter your question ${index + 1}',
                                            labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                color: Theme.of(context).colorScheme.onBackground,
                                                fontWeight: FontWeight.normal
                                            )
                                          ),
                                          controller: textQuestionEditController,
                                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                color: Theme.of(context).colorScheme.onBackground,
                                            )
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text('Enter Options:'),

                                        for (var i = 0; i < optionsCount; i++) ...[
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: "Option ${i + 1}"
                                            ),
                                            controller: optionsList[i],
                                            keyboardType: TextInputType.text,
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                  color: Theme.of(context).colorScheme.onBackground,
                                                  fontWeight: FontWeight.normal
                                              )
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          if (question['type'] == 'multiselect') {
                            final List<TextEditingController> optionsList =[];
                            final textQuestionEditController = TextEditingController();
                            _questionTextFieldController.add(textQuestionEditController);

                            final optionsCount = question['options_count'] ?? 2;
                            for(var i=0; i<optionsCount;i++){
                              final textOptionsEditController = TextEditingController();
                              _optionsTextFieldController.add(textOptionsEditController);
                              optionsList.add(textOptionsEditController);
                            }

                            dynamicQuestionMap["type_$index"] = 'multiselect';
                            dynamicQuestionMap["question_controller_$index"] = textQuestionEditController;
                            dynamicQuestionMap["options_controller_$index"] = optionsList;

                            return Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                Card(
                                  margin: const EdgeInsets.all(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('*Multi choice question'),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                              labelText:
                                              'Enter your question ${index + 1}',
                                            labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                color: Theme.of(context).colorScheme.onBackground,
                                                fontWeight: FontWeight.normal
                                            )
                                          ),
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                            color: Theme.of(context).colorScheme.onBackground,
                                        ),
                                          controller: textQuestionEditController,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text('Enter Options:'),
                                        for (var i = 0; i < optionsCount; i++) ...[
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: "Option ${i + 1}"),
                                            keyboardType: TextInputType.text,
                                              controller: optionsList[i],
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                  color: Theme.of(context).colorScheme.onBackground,
                                                  fontWeight: FontWeight.normal
                                              )
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                        })
                        .map((widget) => Column(children: [widget!]))
                        .toList(),
                  );

                }

                return const Text('Something went wrong!!');
              }),

          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer),
            child: (isLoading) ? const CircularProgressIndicator(): Text(
              'Submit',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
