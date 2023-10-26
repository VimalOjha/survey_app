import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/data/models/question.dart';
import 'package:survey_app/data/models/survey_form.dart';
import 'package:survey_app/presentation/widgets/new_form_widget.dart';

class CreateNewForm extends StatefulWidget{
  const CreateNewForm({super.key});

  @override
  State<CreateNewForm> createState() => _CreateNewFormState();
}

class _CreateNewFormState extends State<CreateNewForm> {

  void saveForm(String title, List<Question> questions){
    print(title);
    addSurveyForm(title, questions);
    print('Form Created Successfully!');
  }

// Add the survey form to Firestore
  Future<void> addSurveyForm(String title, List<Question> questions) async {
    final firestore = FirebaseFirestore.instance;
    final formReference = firestore.collection('survey_forms').doc();
    try {
      await formReference.set({
        'title': title,
        'createdAt' : Timestamp.now(),
        'questions': questions.map((question) => {
          'question': question.questionText,
          'type': question.type,
          'label': question.questionLabel,
          'options': question.options,
        }).toList(),
      });


     SurveyForm surveyForm = SurveyForm(
       id: formReference.id,
       title: title, // Replace with the appropriate field names
       questions: questions, // Assuming 'questions' is a List of questions
     );

     if(!context.mounted) return;
      Navigator.of(context).pop(surveyForm);

    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Form'),
      ),
      body: SingleChildScrollView(
        child:  Column(
          children: [
            NewForm(saveForm: (title, questions){
              saveForm(title, questions);
            }),
          ],
        ),
      ),
    );
  }
}