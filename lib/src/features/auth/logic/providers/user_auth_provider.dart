import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/src/features/auth/data/repositories/user_repository.dart';
import 'package:survey_app/src/features/common/users/data/models/user.dart';

class UserAuthProvider extends ChangeNotifier{
  final UserRepository _userRepository;
  UserAuthProvider(this._userRepository);

  bool isLoading = false;
  bool isLoginMode = true;

  Future<User?> signIn(
      {required String email, required String password}) async {
    User? user;
    isLoading = true;
    notifyListeners();
    try {
       user = await _userRepository.signIn(email: email, password: password);
       isLoading = false;
       notifyListeners();
    } on Exception catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }

    return user;
  }

  void changeMode(bool isLogin){
    isLoginMode = isLogin;
    notifyListeners();
  }

  void signOut(){
    _userRepository.signOut();
  }


  Future<User?> createUser(
      {required String email, required String password}) async {
    User? user;
    isLoading = true;
    notifyListeners();
    try {
      user = await _userRepository.createUser(email: email, password: password);
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }

    return user;
  }

  Future<bool> saveUserData(String uid, Map<String, dynamic> userdata) async{
    return await _userRepository.saveUser(uid, userdata);
  }
}