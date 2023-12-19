import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/features/home/survey/domain/models/question.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';

class SurveyFormRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<SurveyForm> addSurveyForm(String title, List<Question> questions) async {
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
      return surveyForm;

    } on Exception catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<dynamic>>? loadFormConfigData() async {
    String data = "";
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection("form_json_config").get();

      if (querySnapshot.docs.isNotEmpty) {
        print(querySnapshot.docs[0].data() as Map<String, dynamic> );
        final dynamicData =  querySnapshot.docs[0].data() as Map<String, dynamic> ;
        return dynamicData["questions"];
      }else{
        data = await rootBundle.loadString('assets/form_config.json');
      }
    } catch (e) {
      debugPrint('Error fetching data from Firestore: $e');
      data = await rootBundle.loadString('assets/form_config.json');
    }
    final dynamicData = jsonDecode(data);
    //code to add json on firestore
    /*final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      try {
        await _firestore.collection('form_json_config').add(jsonDecode(data));
      } catch (e) {
        print('Error adding data to Firestore: $e');
    }*/
    return dynamicData["questions"];
  }

  Future<bool> submitUserInput(String formId, Map<String, dynamic> formData) async{
   try {
     await firestore
        .collection('users')
        .doc(_auth.currentUser!.uid!)
        .collection('submitted_forms')
        .doc(formId)
        .set(formData);

     return true;
   } on Exception catch (e) {
     debugPrint(e.toString());
    return false;
   }

}

  Future<String> getFormStatus(String formId) async {

    final docSnapshot = await firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('submitted_forms')
        .doc(formId)
        .get();

    if (docSnapshot.exists) {
      // The document exists, check its status
      return AppStrings.labelSubmitted; // Return "SUBMITTED" or "PENDING"
    } else {
      // The document doesn't exist; assume "PENDING"
      return AppStrings.labelPending;
    }
  }

  Future<List<SurveyForm>> loadSurveyForms(List<DocumentSnapshot> currentList, int limit) async {
    try {
      Query query = firestore
          .collection('survey_forms')
          .orderBy('createdAt', descending: true);

      if (currentList.isNotEmpty) {
        query = query.startAfterDocument(currentList.last);
      }

      final querySnapshot =  await query.get();
      List<SurveyForm> surveyList = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> formData = doc.data() as Map<String, dynamic>;

        List<Question> parsedQuestions = List<Question>.from(
          (formData['questions'] as List).map((questionData) {
            return Question.fromJson(questionData);
          }),
        );

        final status = await getFormStatus(doc.id);

        SurveyForm surveyForm = SurveyForm(
          id: doc.id,
          title: formData['title'],
          // Replace with the appropriate field names
          questions: parsedQuestions,
          formStatus: status
        );

        surveyList.add(surveyForm);
      }


      return surveyList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }}