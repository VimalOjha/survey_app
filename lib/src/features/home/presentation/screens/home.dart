import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/src/features/auth/logic/providers/user_auth_provider.dart';
import 'package:survey_app/src/features/home/presentation/widgets/survey_forms_list_widget.dart';
import 'package:survey_app/src/utils/commons/constants/app_strings.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UserAuthProvider authProvider ;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<UserAuthProvider>(context,listen: false);
  }

  void _signOut() async {
    authProvider.signOut();
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
                _signOut();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}