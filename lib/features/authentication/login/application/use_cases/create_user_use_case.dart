import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/user_repository.dart';

class CreateUserUserCase {
  final UserRepository userRepository;
  CreateUserUserCase({required this.userRepository});

  Future<User?> createUser(
      {required String email, required String password}) async {
    User? user;
    try {
      user = await userRepository.createUser(email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
    return user;
  }

}