import 'package:flutter/material.dart';
import 'package:survey_app/core/storage/data/user_storage.dart';
import '../../../../../../features/authentication/login/domain/user_repository.dart';
import '../../domain/models/user.dart';

class UserDataProvider extends ChangeNotifier{
  final UserRepository _userRepository;
  UserDataProvider(this._userRepository);

  void getUserData() async {
    userData = await _userRepository.fetchUserData();
    if(userData != null) {
      UserStorage().setUserData(userData!);
    }
    await Future.delayed(const Duration(seconds: 3));
    loadingUserData = false;
    notifyListeners();
  }

  void setUserData(UserData newUserData){
    userData = newUserData;
    notifyListeners();
  }
  bool loadingUserData = true;
  UserData? userData;
}