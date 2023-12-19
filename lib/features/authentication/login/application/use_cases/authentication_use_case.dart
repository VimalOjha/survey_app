import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/user.dart';
import '../../domain/user_repository.dart';

class AuthenticationUseCase {
  final UserRepository userRepository;
  AuthenticationUseCase({required this.userRepository});

  Future<User?> signIn(
      {required String email, required String password}) async {
    User? user;
    try {
      user = await userRepository.signIn(email: email, password: password);
    } on Exception catch (e) {
      rethrow;
    }
    return user;
  }

  Future<User?> createUser(
      {required String email, required String password}) async {
    User? user;
    try {
      user = await userRepository.createUser(email: email, password: password);
    } on Exception catch (e) {

      rethrow;
    }

    return user;
  }

  void signOut() {
    userRepository.signOut();
  }


  Future<bool> saveUserData(String uid, Map<String, dynamic> userdata) async{
    return await userRepository.saveUser(uid, userdata);
  }

  Future<UserData?> getUserData() async {
    return await userRepository.fetchUserData();
  }

}