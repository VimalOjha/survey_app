import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/configs/utilities/common/presentation/widgets/custom_snackbar.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/configs/utilities/constants/enums/data_state_enum.dart';
import 'package:survey_app/configs/utilities/constants/enums/survey_create_form_state.dart';
import 'package:survey_app/features/home/survey/application/survey_form_bloc.dart';
import 'package:survey_app/features/home/survey/application/survey_form_events.dart';
import 'package:survey_app/features/home/survey/application/survey_form_state.dart';
import 'package:survey_app/features/home/survey/domain/models/question.dart';
import 'package:survey_app/features/home/survey/domain/models/survey_form_create_request.dart';
import 'package:survey_app/features/home/survey/presentation/widgets/new_form_widget.dart';


class CreateNewForm extends StatefulWidget {
  const CreateNewForm({super.key});

  @override
  State<CreateNewForm> createState() => _CreateNewFormState();
}

class _CreateNewFormState extends State<CreateNewForm> {
  bool allowBuild = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    allowBuild = true;
    super.initState();
  }

  void saveForm(String title, List<Question> questions) async {
    debugPrint(title);
    try {
      SurveyFormCreateRequest createRequest = SurveyFormCreateRequest(title: title,createdAt: Timestamp.now(), questions: questions);
      allowBuild = false;
      BlocProvider.of<SurveyFormBloc>(context).add(SaveNewSurveyForm(createRequest: createRequest));
    } on Exception catch (e){
      debugPrint(e.toString());
      debugPrint('Failed to save form!');
    }
  }

  Future<bool> _onBackPressed() {
    BlocProvider.of<SurveyFormBloc>(context)
        .add(FetchSurveyForms());
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyFormBloc, SurveyFormState>(
      listener: (context, state) {
        if (state.surveyCreateFormStatus  == SurveyCreateFormStatus.completed) {
          allowBuild = false;
          Navigator.of(context).pop();
        }
        if (state.dataState == DataState.error) {
          allowBuild = true;
          CustomSnackbar(context)
              .show(message: "Failed to create survey, please try again!");
        }
      },
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.labelTitleCreateForm),

            ),
            body: BlocBuilder<SurveyFormBloc, SurveyFormState>(
                builder: (context, state) {
              if (state.surveyCreateFormStatus == SurveyCreateFormStatus.uploading) {
                return const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 5,
                    ),
                    Text(AppStrings.labelCreatingFormProgressMessage)
                  ],
                ));
              }

              if (allowBuild) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      NewForm(saveForm: (title, questions) {
                        saveForm(title, questions);
                      }),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            })),
      ),
    );
  }
}
