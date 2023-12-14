import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/src/features/surveyform/data/models/question.dart';
import 'package:survey_app/src/features/common/presentation/widgets/custom_snackbar.dart';
import 'package:survey_app/src/features/surveyform/logic/providers/survey_forms_provider.dart';
import 'package:survey_app/src/features/surveyform/presentation/widgets/new_form_widget.dart';
import 'package:survey_app/src/utils/commons/constants/app_strings.dart';

class CreateNewForm extends StatefulWidget{
  const CreateNewForm({super.key});

  @override
  State<CreateNewForm> createState() => _CreateNewFormState();
}

class _CreateNewFormState extends State<CreateNewForm> {
  late final SurveyDataProvider _surveyDataProvider;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);
  }

  void saveForm(String title, List<Question> questions) async{
    print(title);
    try {
      final surveyForm = await _surveyDataProvider.addNewSurveyForm(title, questions);
      if(surveyForm != null) {
        print('Form Created Successfully!');
        if(!context.mounted) return;
        Navigator.of(context).pop(surveyForm);
      }else{
        if(!context.mounted) return;
          CustomSnackbar(context).show(message: "Failed to create survey, please try again!");

      }
    } on Exception catch (e) {
      print('Failed to save form!');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.labelTitleCreateForm),
        ),
        body: Consumer<SurveyDataProvider>(builder: (ctx1, provider, child) {
          if (provider.isUploadingForm) {
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
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                 NewForm(
                        saveForm: (title, questions) {
                          saveForm(title, questions);
                        }),
                ],
              ),
            );
          }
        }));
  }
}