import 'package:flutter/material.dart';
import 'package:survey_app/src/features/auth/data/repositories/user_repository.dart';
import 'package:survey_app/src/features/common/users/data/models/user.dart';

class UserDataProvider extends ChangeNotifier{
  final UserRepository _userRepository;
  UserDataProvider(this._userRepository);

  void getUserData() async {
    userData = await _userRepository.fetchUserData();
    await Future.delayed(const Duration(seconds: 3));
    loadingUserData = false;
    notifyListeners();
  }
  bool loadingUserData = true;
  UserData? userData;
}