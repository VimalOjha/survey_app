import '../../domain/user_repository.dart';

class SignOutUseCase {
  final UserRepository userRepository;

  SignOutUseCase({required this.userRepository});

  Future<void> signOut() => userRepository.signOut();

}