import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/user_repository.dart';

class SignInUseCase {
  final UserRepository userRepository;
  SignInUseCase({required this.userRepository});

  Future<User?> signIn(
      {required String email, required String password}) async {
    User? user;
    try {
      user = await userRepository.signIn(email: email, password: password);
    } on Exception {
      rethrow;
    }
    return user;
  }

}