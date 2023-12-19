import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
abstract class AuthenticationEvent extends Equatable{

}
class OnLoginEvent extends AuthenticationEvent{
  OnLoginEvent(this.email, this.password);
  final String email;
  final String password;

  @override
  List<Object?> get props => [];
}
class OnSignUpEvent extends AuthenticationEvent{
  final String email;
  final String password;
  final String username;
  OnSignUpEvent(this.email, this.password, this.username);

  @override
  List<Object?> get props => [];
}

class OnToggleAuthenticationMode extends AuthenticationEvent{
   OnToggleAuthenticationMode(this.isLoginModel);
   bool isLoginModel;
  @override
  List<Object?> get props => [];
}

class ValidateAuthInput extends AuthenticationEvent {
  final String email;
  final String? username;
  final String password;

  ValidateAuthInput({required this.email, required this.password, this.username});

  @override
  List<Object?> get props => [];
}

class AuthenticationLoggedIn extends AuthenticationEvent {
  @override
    List<Object?> get props => [];
}

class AuthenticationLoggedOut extends AuthenticationEvent {
  AuthenticationLoggedOut();
  @override
  List<Object?> get props => [];
}

class AuthenticationUserCreated extends AuthenticationEvent {
  final User user;
  final String username;
  AuthenticationUserCreated(this.user, this.username);

  @override
  List<Object?> get props => [];
}

class OnLogout extends AuthenticationEvent{
  @override
  List<Object?> get props => [];
}
