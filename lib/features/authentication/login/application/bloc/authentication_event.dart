import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:survey_app/configs/utilities/constants/enums/auth_flow_enum.dart';

enum AuthState{
  authenticated,
  unauthenticated
}

abstract class AuthenticationEvent extends Equatable{

}

class OnToggleAuthenticationMode extends AuthenticationEvent{
   OnToggleAuthenticationMode(this.authFlow);
   final AuthFlow authFlow;
  @override
  List<Object?> get props => [authFlow];
}

class ValidateAuthInput extends AuthenticationEvent {
  final String email;
  final String? username;
  final String password;
  final AuthFlow flow;

  ValidateAuthInput({required this.email, required this.password, this.username, required this.flow});

  @override
  List<Object?> get props => [email, username, password, flow];
}

class AuthenticationLoggedIn extends AuthenticationEvent {
  @override
    List<Object?> get props => [];
}

class AuthenticationUserCreated extends AuthenticationEvent {
  final User user;
  final String username;
  AuthenticationUserCreated(this.user, this.username);

  @override
  List<Object?> get props => [user, username];
}

class OnLogout extends AuthenticationEvent{
  @override
  List<Object?> get props => [];
}


class OnAuthStatusChanged extends AuthenticationEvent {
  final AuthState updatedStatus;
  final User? user;

  OnAuthStatusChanged(this.updatedStatus, { this.user});
  @override
  List<Object?> get props => [updatedStatus];

}
