import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_app/data/models/user.dart';

final _firebase = FirebaseAuth.instance;
class AuthScreen extends StatefulWidget{
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>{
  var _isLogin = true;
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';


  void _submit() async {
    final isValid = _form.currentState!.validate();

    if(!isValid){
      return;
    }

    _form.currentState!.save();
    print(_enteredEmail);
    print(_enteredPassword);

    try {
      if(_isLogin){
        final userCreds = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(userCreds);
      } else {
        final userCreds = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(userCreds);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCreds.user!.uid)
            .set(
            {
              'name' : _enteredUsername,
              'email' : _enteredEmail,
              'user_type': 'user'
            }
            );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication failed!')));
    }
  }

  void saveUserData(UserData user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userModel', jsonEncode(user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(!_isLogin)
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onBackground,
                                    fontWeight: FontWeight.normal
                                )
                              ),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  fontWeight: FontWeight.normal
                              ),
                              autocorrect: false,
                              validator: (value){
                                if(value == null || value.trim().isEmpty || value.trim().length < 4){
                                  return 'Please enter at least 4 characters!';
                                }
                                return null;
                              },
                              onSaved: (value){
                                _enteredUsername = value!;
                              },
                            ),
                          TextFormField(
                            decoration:  InputDecoration(
                              labelText: 'Email Address',
                                labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onBackground,
                                    fontWeight: FontWeight.normal
                                )
                            ),
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.normal
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value){
                              if(value == null || value.trim().isEmpty || !value.contains('@')){
                                return 'Please enter a valid email address!';
                              }
                              return null;
                            },
                            onSaved: (value){
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration:  InputDecoration(
                              labelText: 'Password',
                              labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  fontWeight: FontWeight.normal
                              )
                            ),
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.normal
                            ),
                            obscureText: true,
                            validator: (value){
                              if(value == null || value.trim().length < 6 ){
                                return 'Password must be at least 6 characters long!';
                              }
                              return null;
                            },
                            onSaved: (value){
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12,),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer
                            ),
                            child: Text(_isLogin ? 'Login' : 'Signup',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.normal
                                )),
                          ),
                          TextButton(
                              onPressed: (){
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'I have an account.',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.normal
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}