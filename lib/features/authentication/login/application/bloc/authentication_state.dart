import 'package:firebase_auth/firebase_auth.dart';
import 'package:survey_app/configs/utilities/constants/enums/auth_flow_enum.dart';
import 'package:survey_app/configs/utilities/constants/enums/data_state_enum.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_event.dart';

class AuthenticationState {
  final String userName;
  final String email;
  final String password;
  final DataState dataState;
  final AuthState authState;
  final User? loggedInUser;
  final AuthFlow authFlow;
  final String errorMessage;

  AuthenticationState({
    this.userName = '',
    this.email = '',
    this.password = '',
    this.dataState = DataState.none,
    this.authState = AuthState.unauthenticated,
    this.loggedInUser,
    this.authFlow = AuthFlow.login,
    this.errorMessage = '',
  });

  AuthenticationState copyWith({
    String? userName,
    String? email,
    String? password,
    DataState? dataState,
    AuthState? authState,
    User? loggedInUser,
    AuthFlow? authFlow,
    String? errorMessage,
  }) {
    return AuthenticationState(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      dataState: dataState ?? this.dataState,
      authState: authState ?? this.authState,
      loggedInUser: loggedInUser ?? this.loggedInUser,
      authFlow: authFlow ?? this.authFlow,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
