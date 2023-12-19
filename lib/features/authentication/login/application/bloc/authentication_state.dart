import 'package:firebase_auth/firebase_auth.dart';
import 'package:survey_app/features/home/survey/application/survey_form_state.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final User user;

  AuthenticationAuthenticated({required this.user});
}

class AuthenticationUnauthenticated extends AuthenticationState{}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  AuthenticationFailure({required this.error});
}

class LoginModeChanged extends AuthenticationState {
  final bool isLoginMode;
  LoginModeChanged({required this.isLoginMode});
}
