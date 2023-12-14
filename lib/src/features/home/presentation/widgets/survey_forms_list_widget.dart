import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/src/features/common/presentation/widgets/loading_circular_progress.dart';
import 'package:survey_app/src/features/common/users/logic/providers/user_data_provider.dart';
import 'package:survey_app/src/features/surveyform/data/models/question.dart';
import 'package:survey_app/src/features/surveyform/data/models/survey_form.dart';
import 'package:survey_app/src/features/surveyform/data/repositories/survey_form_repository.dart';
import 'package:survey_app/src/features/surveyform/logic/providers/survey_forms_provider.dart';
import 'package:survey_app/src/features/surveyform/presentation/screens/user_survey_form.dart';
import 'package:survey_app/src/features/surveyform/presentation/widgets/form_status_widget.dart';
import 'package:survey_app/src/utils/commons/constants/app_strings.dart';
import '../../../surveyform/presentation/screens/create_new_form.dart';

class SurveyFormsList extends StatefulWidget {
  const SurveyFormsList({super.key});

  @override
  State<SurveyFormsList> createState() => _SurveyFormsListState();
}

class _SurveyFormsListState extends State<SurveyFormsList> {
  late UserDataProvider _provider;
  late SurveyDataProvider _surveyDataProvider;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<UserDataProvider>(context, listen: false);
    _surveyDataProvider = Provider.of<SurveyDataProvider>(context,listen: false);
    _provider.getUserData();
    _surveyDataProvider.getSurveyList();
  }
  void _addNewForm() async {
    final surveyForm =
        await Navigator.of(context).push<SurveyForm>(MaterialPageRoute(
      builder: (ctx) => ChangeNotifierProvider<SurveyDataProvider>(
          create: (ctx1) => SurveyDataProvider(SurveyFormRepository()),
          child: const CreateNewForm()) ,
    ));

    if (surveyForm != null) {
      _surveyDataProvider.addNewFormToList(surveyForm);
    }
  }

  Future<String> _submitForm(String id, String title, List<Question> questions) async {
    final formId = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (ctx) =>
            ChangeNotifierProvider<SurveyDataProvider>(
                create: (ctx1) => SurveyDataProvider(SurveyFormRepository()),
                child: SurveyFormScreen(formId: id, title: title, questions: questions)))
            );
    if (formId == null) return '';

    return AppStrings.labelSubmitted;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
        builder: (ctx1, userDataProvider, child) {

      return Consumer<SurveyDataProvider>(
          builder: (ctx2, surveyDataProvider, child) {
       if (surveyDataProvider.isLoadingData || userDataProvider.loadingUserData){
          return const LoadingCircular(label : AppStrings.labelProgressLoadingSurveyForms);
        }

       if (userDataProvider.userData == null || surveyDataProvider.surveyList == null ) {
          return const Center(
            child: Text(AppStrings.labelSomethingWentWrong),
          );
        }

       if(surveyDataProvider.surveyList!.isEmpty){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStrings.labelNoFormsFound,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(
                      color:
                      Theme.of(context).colorScheme.onBackground,
                    )),
                const SizedBox(
                  height: 18,
                ),
                if (userDataProvider.userData != null && userDataProvider.userData!.isAdmin())
                  ElevatedButton.icon(
                    onPressed: () {
                      _addNewForm();
                    },
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: Text(
                      AppStrings.labelButtonCreateNew,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                          color:
                          Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.normal),
                    ),
                  )
              ],
            ),
          );
        }

        if (surveyDataProvider.surveyList!.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.only(
                            bottom: 40, left: 13, right: 13),
                        itemCount: surveyDataProvider.surveyList!.length,
                        itemBuilder: (ctx, index) {
                          final form = surveyDataProvider.surveyList![index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: InkWell(
                              onTap: (userDataProvider.userData!.isAdmin() || form.isSubmitted()) ? null : () async {

                                String newStatus = await _submitForm(
                                    form.id, form.title, form.questions);
                                print(newStatus);
                                if (newStatus.isNotEmpty) {
                                  surveyDataProvider.setSurveyFormStatus(form.id, newStatus);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(form.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                fontWeight: FontWeight.normal)),
                                    if (userDataProvider.userData!.isNormalUser())
                                      FormStatus(status: form.formStatus!,)
                              ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),

                  if (userDataProvider.userData != null && userDataProvider.userData!.isAdmin())
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _addNewForm();
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        label: Text(
                          AppStrings.labelButtonCreateNew,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.normal),
                        ),
                      ),
                    )
                ],
              );
        }
          return const SizedBox.shrink();
      });
    });
  }

}