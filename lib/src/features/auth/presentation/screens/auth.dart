import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/src/features/auth/logic/providers/user_auth_provider.dart';
import 'package:survey_app/src/features/common/presentation/widgets/custom_snackbar.dart';
import 'package:survey_app/src/utils/commons/constants/app_strings.dart';


class AuthScreen extends StatefulWidget{
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>{
  late final UserAuthProvider _authProvider;
  final _form = GlobalKey<FormState>();
  final _enteredEmail = TextEditingController();
  final _enteredUsername = TextEditingController();
  final _enteredPassword = TextEditingController();


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
    _authProvider = Provider.of<UserAuthProvider>(context, listen: false);
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();
    CustomSnackbar customSnackbar = CustomSnackbar(context);
    if(!isValid){
      return;
    }

    _form.currentState!.save();
    debugPrint(_enteredEmail.text);
    debugPrint(_enteredPassword.text);

    try {
      if (_authProvider.isLoginMode) {
        final userCreds = await _authProvider.signIn(
            email: _enteredEmail.text, password: _enteredPassword.text);

        debugPrint(userCreds?.displayName);
      } else {
        final userCreds = await _authProvider.createUser(
            email: _enteredEmail.text, password: _enteredPassword.text);

        if (userCreds != null) {
        bool isSuccess =  await _authProvider.saveUserData(userCreds.uid, {
            'name': _enteredUsername.text,
            'email': _enteredEmail.text,
            'user_type': 'user'
          });
        }
      }
    } catch (error) {
      debugPrint(error.toString());
      customSnackbar.show(message: error.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Consumer<UserAuthProvider>(
        builder: (ctx, provider, child){
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
                              if(!provider.isLoginMode)
                                TextFormField(
                                  controller: _enteredUsername,
                                  enabled: !provider.isLoading,
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
                                enabled: !provider.isLoading,
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
                                enabled: !provider.isLoading,
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
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme
                                        .of(context)
                                        .colorScheme
                                        .primaryContainer
                                ),
                                child: provider.isLoading ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ) : Text(provider.isLoginMode
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
                                    setState(() {
                                      provider.isLoginMode = !provider.isLoginMode;
                                    });
                                  },
                                  child: Text(provider.isLoginMode
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