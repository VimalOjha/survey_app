import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/configs/services/storage_service.dart';
import 'package:survey_app/features/authentication/login/domain/models/user.dart';



class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
  Future<User?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
     String errorMessage = "Something went wrong!!";

      switch (e.code) {
        case 'INVALID_LOGIN_CREDENTIALS' :
          errorMessage = "Invalid credentials Or User not found!";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address";
          break;
        case 'user-not-found':
          errorMessage = "User not found";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password";
          break;
        case 'email-already-in-use' :
          errorMessage = "Email is already in use, please use different email address.";
        case 'network-request-failed' :
          errorMessage = "Please check your internet connection";
          break;
      // Add more cases for other Firebase Auth error codes as needed
      }
      throw Exception(errorMessage);
    }
  }

  Future<User?> createUser({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong!!";

      switch (e.code) {
        case 'INVALID_LOGIN_CREDENTIALS' :
          errorMessage = "Invalid credentials Or User not found!";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address";
          break;
        case 'user-not-found':
          errorMessage = "User not found";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password";
          break;
        case 'email-already-in-use' :
          errorMessage = "Email is already in use, please use different email address.";
        case 'network-request-failed' :
          errorMessage = "Please check your internet connection";
          break;
      // Add more cases for other Firebase Auth error codes as needed
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> signOut() async {
    final SharedPreferencesService prefs = SharedPreferencesService();
    prefs.clearPreference();
    await _auth.signOut();
  }

  Future<bool> saveUser(String uid, Map<String, dynamic> userdata) async {
    try {
      await _instance
          .collection('users')
          .doc(uid)
          .set(userdata);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<UserData?> fetchUserData() async {
    try {
      UserData? userData;
      final currentUser  = _auth.currentUser!;
      final SharedPreferencesService prefs = SharedPreferencesService();
      final String? userModelJson = prefs.getLoggedInUser();

      if(userModelJson == null) {
        debugPrint("fetching userdata from firestore");
        final userDatabyId = await _instance.collection('users')
            .doc(currentUser.uid)
            .get();

        userData = UserData(
            id: currentUser!.uid,
            name: userDatabyId.data()!['name'],
            email: userDatabyId.data()!['email'],
            userType: userDatabyId.data()!['user_type']);
        debugPrint(jsonEncode(userData!.toJson()));

        prefs.saveLoggedInUser(jsonEncode(userData!.toJson()));

      }else{
        debugPrint("fetching userdata from preference");
        debugPrint(jsonDecode(userModelJson).toString());
        userData = UserData.fromJson(jsonDecode(userModelJson));
      }

      return userData;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}