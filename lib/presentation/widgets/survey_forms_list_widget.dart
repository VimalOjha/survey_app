import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_app/data/models/question.dart';
import 'package:survey_app/data/models/survey_form.dart';
import 'package:survey_app/data/models/user.dart';
import 'package:survey_app/presentation/screens/user_survey_form.dart';

import '../screens/create_new_form.dart';

class SurveyFormsList extends StatefulWidget {
  const SurveyFormsList({super.key});

  @override
  State<SurveyFormsList> createState() => _SurveyFormsListState();
}

class _SurveyFormsListState extends State<SurveyFormsList> {
  final List<SurveyForm> _surveyList = [];
  UserData? userData;
  final currentUser  = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userModelJson = prefs.getString('userModel');
    if(userModelJson == null) {
      final userDatabyId = await FirebaseFirestore.instance.collection('users')
          .doc(currentUser.uid)
          .get();
      setState(() {
        userData = UserData(
            id: currentUser!.uid,
            name: userDatabyId.data()!['name'],
            email: userDatabyId.data()!['email'],
            userType: userDatabyId.data()!['user_type']);
        print(jsonEncode(userData!.toJson()));

        prefs.setString('userModel', jsonEncode(userData!.toJson()));
      });
    }else{
      setState(() {
        print(jsonDecode(userModelJson));
        userData = UserData.fromJson(jsonDecode(userModelJson));
      });
    }
  }

  Future<String> getFormStatus(String formId) async {

    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('submitted_forms')
        .doc(formId)
        .get();

    if (docSnapshot.exists) {
      // The document exists, check its status
      return 'SUBMITTED'; // Return "SUBMITTED" or "PENDING"
    } else {
      // The document doesn't exist; assume "PENDING"
      return 'PENDING';
    }
  }

  void _addNewForm() async {
    final newForm = await Navigator.of(context).push<SurveyForm>(
        MaterialPageRoute(builder: (ctx) => const CreateNewForm()));
    if (newForm == null) return;

    setState(() {
      _surveyList.add(newForm);
    });
  }

  Future<String> _submitForm(String id, String title, List<Question> questions) async {
    final formId = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (ctx) => SurveyFormScreen(formId: id, title: title, questions: questions)));
    if (formId == null) return '';

    return 'SUBMITTED';
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance
        .collection('survey_forms')
        .orderBy('createdAt', descending: true)
        .snapshots(),
      builder: (ctx, formSnapshots) {
        if(formSnapshots.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(!formSnapshots.hasData || formSnapshots.data!.docs.isEmpty){
          return  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No Forms Found',
                   style: Theme.of(context).textTheme.titleMedium!.copyWith(
                       color: Theme.of(context).colorScheme.onBackground,
                   )),
                const SizedBox(height: 18,),
                if(userData != null && userData!.userType == 'admin')
                  ElevatedButton.icon(
                    onPressed: () {
                      _addNewForm();
                    },
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: Text(
                      'Create New Form',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.normal),
                    ),
                  )
              ],
            ),
          );
        }
        if(formSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
        _surveyList.clear();
        final loadedForms = formSnapshots.data!;
        for(final item in loadedForms.docs){
          final Map<String, dynamic> formData = item.data();

          List<Question> parsedQuestions = List<Question>.from((formData['questions'] as List).map((questionData) {
            // Parse each question from questionData
            return Question(
              questionText: questionData['question'],
              type: questionData['type'],
              questionLabel: questionData['label'],
              options: questionData[
              'options'] == null ? null :  List<String>.from(questionData[
                  'options']),
            );
          }));

          SurveyForm surveyForm = SurveyForm(
            id: item.id,
            title: formData['title'], // Replace with the appropriate field names
            questions: parsedQuestions, // Assuming 'questions' is a List of questions
          );
          _surveyList.add(surveyForm);
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
                itemCount: _surveyList.length,
                itemBuilder: (ctx, index) {
                  final form = _surveyList[index];
                  String status = '';
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () async {
                        if(userData?.userType == 'admin' || status == "SUBMITTED"){
                          return;
                        }
                        String newStatus = await _submitForm(form.id, form.title, form.questions);
                        print(newStatus);
                        if(newStatus.isNotEmpty) {
                          setState(() {
                          status = newStatus;
                        });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(form.title,
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  fontWeight: FontWeight.normal
                                )),

                            if(userData != null && userData!.userType == 'user')
                            FutureBuilder<String>(
                                  future: getFormStatus(form.id),
                                  builder: (ctx, state) {
                                    if (state.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (state.connectionState ==
                                            ConnectionState.done &&
                                        state.hasData) {
                                      status = state.data!;
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: status == 'SUBMITTED'
                                              ? Colors.green
                                              : Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          status,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      );
                                    }

                                    return const Text('');
                                  })
                            ],
                        ),
                      ),
                    ),
                  );
                  }
              ),
            ),

            if(userData != null && userData!.userType == 'admin')
              ElevatedButton.icon(
                onPressed: () {
                  _addNewForm();
                },
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  'Create New Form',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.normal),
                ),
              )
          ],
        );
      }
    ,);


  }
}