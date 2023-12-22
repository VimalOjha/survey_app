import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/configs/utilities/constants/enums/auth_flow_enum.dart';
import 'package:survey_app/configs/utilities/constants/enums/data_state_enum.dart';
import 'package:survey_app/core/storage/data/user_storage.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_event.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_state.dart';
import 'package:survey_app/features/authentication/login/application/use_cases/create_user_use_case.dart';
import 'package:survey_app/features/authentication/login/application/use_cases/get_user_use_case.dart';
import 'package:survey_app/features/authentication/login/application/use_cases/save_user_use_case.dart';
import 'package:survey_app/features/authentication/login/application/use_cases/sign_in_use_case.dart';
import 'package:survey_app/features/authentication/login/application/use_cases/sign_out_use_case.dart';
import 'package:survey_app/features/authentication/login/domain/models/user_data.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInUseCase authUseCase;
  final SignOutUseCase signOutUseCase;
  final CreateUserUserCase createUserUserCase;
  final GetUserUseCase getUserUseCase;
  final SaveUserUseCase saveUserUseCase;
  late StreamSubscription<User?> _authStreamSubscription;


  AuthenticationBloc(
      {required this.authUseCase,
        required this.signOutUseCase,
        required this.createUserUserCase,
        required this.getUserUseCase,
        required this.saveUserUseCase})
      : super(AuthenticationState()) {
    on<OnAuthStatusChanged>(_processOnAuthStateChangedEvent);
    on<AuthenticationLoggedIn>(_initializeAuthStateListener);
    on<OnToggleAuthenticationMode>(_onToggleLoginMode);
    on<ValidateAuthInput>(_onIsValidateAuthInput);
    on<OnLogout>(_onLogout);
  }

  @override
  Future<void> close() {
    _authStreamSubscription
        .cancel(); // Cancel the subscription when the Bloc is closed
    return super.close();
  }

  FutureOr<void> _processOnAuthStateChangedEvent(
      OnAuthStatusChanged event, Emitter<AuthenticationState> emit) {
    final loggedInUser = event.user;
    if (event.updatedStatus == AuthState.authenticated &&
        loggedInUser != null) {
      emit(state.copyWith(
          loggedInUser: loggedInUser, authState: AuthState.authenticated));
    } else {
      emit(state.copyWith(
          loggedInUser: null, authState: AuthState.unauthenticated));
    }
  }

  FutureOr<void> _initializeAuthStateListener(
      AuthenticationLoggedIn event, Emitter<AuthenticationState> emit) {
    _authStreamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) async {
          try {
            if (user != null) {
              UserData? data = await getUserUseCase.getUserData();
              if (data != null) {
                UserStorage().setUserData(data);

                add(OnAuthStatusChanged(AuthState.authenticated, user: user));
              } else {
                add(OnAuthStatusChanged(AuthState.unauthenticated));
              }
            } else {
              add(OnAuthStatusChanged(AuthState.unauthenticated));
            }
          } on Exception catch (e) {
            debugPrint(e.toString());
            add(OnAuthStatusChanged(AuthState.unauthenticated));
          }
        });
  }

  FutureOr<void> _onToggleLoginMode(
      OnToggleAuthenticationMode event, Emitter<AuthenticationState> emit) {
    emit(state.copyWith(authFlow: event.authFlow));
  }

  FutureOr<void> _onIsValidateAuthInput(
      ValidateAuthInput event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(dataState: DataState.loading));

    final validationError = _validateInputs(event);
    if (validationError.isEmpty) {
      if (event.flow == AuthFlow.login) {
        try {
          final currentUser = await authUseCase.signIn(
              email: event.email, password: event.password);
          emit(state.copyWith(dataState: DataState.loaded));
          add(OnAuthStatusChanged(AuthState.authenticated, user: currentUser));
        } on FirebaseAuthException catch (e) {
          emit(state.copyWith(
              errorMessage: e.message ?? "Unknown Error!!",
              dataState: DataState.error));
        }
      } else {
        try {
          final user = await createUserUserCase.createUser(
              email: event.email, password: event.password);

          await saveUserUseCase.saveUserData(user!.uid, {
            'id': user.uid,
            'name': event.username,
            'email': event.email,
            'user_type': 'user'
          });
          emit(state.copyWith(dataState: DataState.loaded));
          emit(state.copyWith(authFlow: AuthFlow.login));
          add(OnAuthStatusChanged(AuthState.authenticated, user: user));
        } on FirebaseAuthException catch (e) {
          emit(state.copyWith(
              errorMessage: e.message ?? "Unknown Error!!",
              dataState: DataState.error));
        }
      }
    } else {
      emit(state.copyWith(
          errorMessage: validationError, dataState: DataState.error));
    }
  }

  String _validateInputs(ValidateAuthInput event) {
    if (event.email.isEmpty || !event.email.contains('@')) {
      return AppStrings.errorEmailAddress;
    }
    if (event.password.isEmpty || event.password.length < 6) {
      return AppStrings.errorPassword;
    }

    if (event.flow == AuthFlow.signup &&
        event.username != null &&
        event.username!.isEmpty) {
      return AppStrings.errorEnterName;
    }

    return '';
  }

  FutureOr<void> _onLogout(OnLogout event, Emitter<AuthenticationState> emit) async {
    await signOutUseCase.signOut();
  }
}
