import '../../domain/user_repository.dart';

class SaveUserUseCase {
  final UserRepository userRepository;
  SaveUserUseCase({required this.userRepository});

  Future<bool> saveUserData(String uid, Map<String, dynamic> userdata) async{
    return await userRepository.saveUser(uid, userdata);
  }
}