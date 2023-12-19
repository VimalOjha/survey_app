import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/core/storage/data/user_storage.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_event.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_state.dart';

import 'package:survey_app/features/authentication/login/application/use_cases/authentication_use_case.dart';
import 'package:survey_app/features/authentication/login/domain/models/user.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationUseCase authUseCase;
  bool isLoginMode = true;
  late StreamSubscription<User?> _authStreamSubscription;


  AuthenticationBloc({required this.authUseCase}) : super(AuthenticationInitial()){
    //on<AuthenticationLoggedIn>(initializeAuthStateListener);
    on<AuthenticationLoggedOut>(_onAuthenticationUnauthenticated);
    on<OnLoginEvent>(_onAuthenticationLogin);
    on<OnToggleAuthenticationMode>(_onToggleLoginMode);
    on<ValidateAuthInput>(_onIsValidateAuthInput);
    on<OnLogout>(_onLogout);
  }

 // stream listen for firebase authentication to-do
/*
  void initializeAuthStateListener(AuthenticationLoggedIn event, Emitter<AuthenticationState> emitter) async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      try {
        if (user != null) {
          //UserData? data = await authUseCase.getUserData();
         */
/* if(data != null) {
            UserStorage().setUserData(data);*//*

            emitter(AuthenticationAuthenticated(user: user));
         */
/* } else {
            emitter(AuthenticationUnauthenticated());
          }*//*

        } else {
          emitter(AuthenticationUnauthenticated());
        }
      } on Exception catch (e) {
        print(e);
      }
    });
  }
*/

  /*void _onAuthenticationLoggedIn(AuthenticationLoggedIn event, Emitter<AuthenticationState> emitter){
    emitter(AuthenticationAuthenticated(user: event.user));
  }*/
  void _onAuthenticationUnauthenticated(AuthenticationLoggedOut event, Emitter<AuthenticationState> emitter){
    emitter(AuthenticationUnauthenticated());
  }
  void _onAuthenticationLogin(OnLoginEvent event, Emitter<AuthenticationState> emitter) async {
    emitter(AuthenticationLoading());
    try {
      final userData = await authUseCase.signIn(
          email: event.email, password: event.password);
      emitter( AuthenticationAuthenticated(user: userData!));
    } catch (error) {
      emitter( AuthenticationFailure(error: error.toString()));
    }
  }
  void _onToggleLoginMode(OnToggleAuthenticationMode event, Emitter<AuthenticationState> emitter){
     isLoginMode = event.isLoginModel;
     emitter(LoginModeChanged(isLoginMode: isLoginMode));
  }
  void _onIsValidateAuthInput(ValidateAuthInput event, Emitter<AuthenticationState> emitter) async{
    emitter (AuthenticationLoading());
    if (_validateInputs(event)) {
      if (isLoginMode) {
        try {

          final currentUser = await authUseCase.signIn(
              email: event.email, password: event.password);

          final userData = await authUseCase.getUserData();

          emitter (AuthenticationAuthenticated(user: currentUser!));
        } catch (error) {
          emitter( AuthenticationFailure(error: error.toString()));
        }
      } else {
        try {
          final userData = await authUseCase.createUser(
              email: event.email, password: event.password);

          await authUseCase.saveUserData(userData!.uid, {
            'name': event.username,
            'email': event.email,
            'user_type': 'user'
          });

          emitter( AuthenticationAuthenticated(user: userData!));
        } catch (error) {
          emitter (AuthenticationFailure(error: error.toString()));
        }
      }
    } else {
      emitter( AuthenticationFailure(error: "Invalid Inputs"));
    }
  }

  bool _validateInputs(ValidateAuthInput event) {

    bool isValid = true;
    if (event.email.isEmpty || !event.email.contains('@')) {
      isValid = false;
    }
    if (event.password.isEmpty || event.password.length < 6) {
      isValid = false;
    }

    if (!isLoginMode && event.username != null && event.username!.isEmpty) {
      isValid = false;
    }

    return isValid;
  }

  void _onLogout(OnLogout event, Emitter<AuthenticationState> emitter) {
    authUseCase.signOut();
  }
  @override
  Future<void> close() {
    _authStreamSubscription.cancel(); // Cancel the subscription when the Bloc is closed
    return super.close();
  }
}
