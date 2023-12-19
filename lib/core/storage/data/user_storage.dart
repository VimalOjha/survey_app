import 'package:survey_app/features/authentication/login/domain/models/user.dart';

class UserStorage{
  UserData? _userData;

  static final UserStorage instance = UserStorage._internal();

  factory UserStorage(){
    return instance;
  }

  UserStorage._internal();
  UserData? get userData => _userData;

  void setUserData(UserData userData){
    _userData = userData;
  }

}