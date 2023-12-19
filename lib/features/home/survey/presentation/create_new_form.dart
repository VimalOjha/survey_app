import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/configs/utilities/common/presentation/widgets/custom_snackbar.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/features/home/survey/application/survey_form_bloc.dart';
import 'package:survey_app/features/home/survey/application/survey_form_events.dart';
import 'package:survey_app/features/home/survey/application/survey_form_state.dart';
import 'package:survey_app/features/home/survey/domain/models/question.dart';
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
    print(title);
    try {
      allowBuild = false;
      BlocProvider.of<SurveyFormBloc>(context)
          .add(SaveNewSurveyForm(title, questions));
    } on Exception catch (e) {
      print('Failed to save form!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyFormBloc, SurveyFormState>(
      listener: (context, state) {
        if (state is SurveyFormFetched) {
          allowBuild = false;
          Navigator.of(context).pop();
        }
        if (state is SurveyFormFetchFailure) {
          allowBuild = true;
          CustomSnackbar(context)
              .show(message: "Failed to create survey, please try again!");
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.labelTitleCreateForm),
          ),
          body: BlocBuilder<SurveyFormBloc, SurveyFormState>(
              builder: (context, state) {
            if (state is SurveyFormLoading) {
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
    );
  }
}
