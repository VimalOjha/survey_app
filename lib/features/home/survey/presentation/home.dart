import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_bloc.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_event.dart';
import 'package:survey_app/features/authentication/login/application/bloc/authentication_state.dart';
import 'package:survey_app/features/home/survey/presentation/widgets/survey_forms_list_widget.dart';
import '../../../authentication/login/presentation/auth.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.labelConfirmLogout),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppStrings.labelLogoutConfirmation,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppStrings.labelCancel,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                AppStrings.labelLogout,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                // Perform logout logic here
                Navigator.of(dialogContext).pop();
                // Call your logout function here
                BlocProvider.of<AuthenticationBloc>(context).add(OnLogout());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state){
        if(state.authState == AuthState.unauthenticated) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const AuthScreen()));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.labelTitleSurveyForms),
          actions: [
            IconButton(
              onPressed: (){
                _showLogoutConfirmationDialog(context);
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ],
        ),
        body:  const Column(
          children:  [
            Expanded(
                child: SurveyFormsList()
            ),

          ],
        ),
      ),
    );
  }
}