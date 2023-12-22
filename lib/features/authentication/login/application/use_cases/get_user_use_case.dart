import '../../domain/models/user_data.dart';
import '../../domain/user_repository.dart';

class GetUserUseCase {
  final UserRepository userRepository;
  GetUserUseCase({required this.userRepository});

  Future<UserData?> getUserData() async {
    return await userRepository.fetchUserData();
  }

}