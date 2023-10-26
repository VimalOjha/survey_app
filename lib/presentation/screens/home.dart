
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_app/data/models/user.dart';
import 'package:survey_app/presentation/widgets/survey_forms_list_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserData? userData;
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    final currentUser  = FirebaseAuth.instance.currentUser!;
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

  void _signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Forms'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
      body:  const Column(
        children:  [
          Expanded(
              child: SurveyFormsList()
          ),

        ],
      ),
    );
  }
}