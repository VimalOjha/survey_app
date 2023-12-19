import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/configs/utilities/common/presentation/widgets/custom_snackbar.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_bloc.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_event.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_state.dart';

class AuthScreen extends StatefulWidget{
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>{
  final _form = GlobalKey<FormState>();
  final _enteredEmail = TextEditingController();
  final _enteredUsername = TextEditingController();
  final _enteredPassword = TextEditingController();
  bool isLoginMode = true;

  @override
  void dispose() {
    _enteredEmail.dispose();
    _enteredUsername.dispose();
    _enteredPassword.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state){
          if(state is AuthenticationFailure){
            CustomSnackbar customSnackbar = CustomSnackbar(context);
            debugPrint(state.error.toString());
            customSnackbar.show(message: state.error.toString(), isError: true);
          }
        },
        builder: (context, state) {
          if(state is LoginModeChanged){
            isLoginMode = state.isLoginMode;
          }
         return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if(!isLoginMode)
                              TextFormField(
                                controller: _enteredUsername,
                                enabled: state is! AuthenticationLoading,
                                decoration: InputDecoration(
                                    labelText: AppStrings.labelName,
                                    labelStyle: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontWeight: FontWeight.normal
                                    )
                                ),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.normal
                                ),
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null || value
                                      .trim()
                                      .isEmpty || value
                                      .trim()
                                      .length < 4) {
                                    return AppStrings.errorEnterName;
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  //_enteredUsername = value!;
                                },
                              ),
                              TextFormField(
                                enabled: state is! AuthenticationLoading,
                                controller: _enteredEmail,
                                decoration: InputDecoration(
                                    labelText: AppStrings.labelEmailAddress,
                                    labelStyle: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontWeight: FontWeight.normal
                                    )
                                ),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.normal
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null || value
                                      .trim()
                                      .isEmpty || !value.contains('@')) {
                                    return AppStrings.errorEmailAddress;
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  //_enteredEmail = value!;
                                },
                              ),
                              TextFormField(
                                enabled: state is! AuthenticationLoading,
                                controller: _enteredPassword,
                                decoration: InputDecoration(
                                    labelText: AppStrings.labelPassword,
                                    labelStyle: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontWeight: FontWeight.normal
                                    )
                                ),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.normal
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value
                                      .trim()
                                      .length < 6) {
                                    return AppStrings.errorPassword;
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  //_enteredPassword = value!;
                                },
                              ),
                              const SizedBox(height: 12,),
                              ElevatedButton(
                                onPressed: () {
                                  authBloc.add(ValidateAuthInput(email: _enteredEmail.text.trim(),
                                      password:  _enteredPassword.text.trim(),
                                      username: isLoginMode ? null : _enteredUsername.text.trim()));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme
                                        .of(context)
                                        .colorScheme
                                        .primaryContainer
                                ),
                                child: state is AuthenticationLoading ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ) : Text( isLoginMode
                                    ? AppStrings.labelLogin
                                    : AppStrings.labelSignup,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.normal
                                    )),
                              ),
                              TextButton(
                                  onPressed: () {
                                    authBloc.add(OnToggleAuthenticationMode(!isLoginMode));
                                  },
                                  child: Text(isLoginMode
                                      ? AppStrings.labelCreateAccount
                                      : AppStrings.labelAlreadyHaveAccount,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.normal
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}