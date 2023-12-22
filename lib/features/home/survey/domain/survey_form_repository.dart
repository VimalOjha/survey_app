import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_app/configs/utilities/constants/app_keys.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form_create_request.dart';

class SurveyFormRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<SurveyForm> addSurveyForm(SurveyFormCreateRequest request) async {
    final formReference = firestore.collection(AppKeys.kCollectionSurveyForms).doc();

    try {
      await formReference.set(request.toJson());

      SurveyForm surveyForm = SurveyForm(
        id: formReference.id,
        title: request.title, // Replace with the appropriate field names
        questions: request.questions, // Assuming 'questions' is a List of questions
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
      QuerySnapshot querySnapshot = await firestore.collection(AppKeys.kCollectionFormJsonConfig).get();

      if (querySnapshot.docs.isNotEmpty) {
        final dynamicData =  querySnapshot.docs[0].data() as Map<String, dynamic> ;
        return dynamicData[AppKeys.kQuestions];
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
    return dynamicData[AppKeys.kQuestions];
  }

  Future<bool> submitUserInput(String formId, Map<String, dynamic> formData) async{
   try {
     await firestore
        .collection(AppKeys.kCollectionUsers)
        .doc(_auth.currentUser!.uid)
        .collection(AppKeys.kSubmittedForms)
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
        .collection(AppKeys.kCollectionUsers)
        .doc(_auth.currentUser!.uid)
        .collection(AppKeys.kSubmittedForms)
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
          .collection(AppKeys.kCollectionSurveyForms)
          .orderBy(AppKeys.kCreatedAt, descending: true);

      if (currentList.isNotEmpty) {
        query = query.startAfterDocument(currentList.last);
      }

      final querySnapshot =  await query.get();
      List<SurveyForm> surveyList = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> formData = doc.data() as Map<String, dynamic>;
        final status = await getFormStatus(doc.id);
        SurveyForm surveyForm = SurveyForm.fromJson(formData);
        surveyForm.id = doc.id;
        surveyForm.formStatus = status;
        surveyList.add(surveyForm);
      }

      return surveyList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }}