import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/configs/utilities/common/presentation/widgets/loading_circular_progress.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/core/storage/data/user_storage.dart';
import 'package:survey_app/features/home/survey/application/survey_form_bloc.dart';
import 'package:survey_app/features/home/survey/application/survey_form_events.dart';
import 'package:survey_app/features/home/survey/application/survey_form_state.dart';
import 'package:survey_app/features/home/survey/domain/models/question.dart';
import 'package:survey_app/features/home/survey/presentation/create_new_form.dart';
import 'package:survey_app/features/home/survey/presentation/user_survey_form.dart';
import 'package:survey_app/features/home/survey/presentation/widgets/form_status_widget.dart';


class SurveyFormsList extends StatefulWidget {
  const SurveyFormsList({super.key});

  @override
  State<SurveyFormsList> createState() => _SurveyFormsListState();
}

class _SurveyFormsListState extends State<SurveyFormsList> {
  late SurveyFormBloc surveyFormBloc;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    surveyFormBloc = BlocProvider.of<SurveyFormBloc>(context);
    surveyFormBloc.add(FetchSurveyForms());
  }
  void _addNewForm() {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const CreateNewForm()));
  }

  _submitForm(String id, String title, List<Question> questions) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>  SurveyFormScreen(formId: id, title: title, questions: questions)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyFormBloc, SurveyFormState>(
      builder:(context, state){
        if(state is SurveyFormLoading) {
            return const LoadingCircular(
                label: AppStrings.labelProgressLoadingSurveyForms);
        }
        if(state is SurveyFormFetchFailure)
        {
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
                      if (UserStorage().userData!.isAdmin())
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

              if (state is SurveyFormFetched) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.only(
                              bottom: 40, left: 13, right: 13),
                          itemCount: state.surveyFormsList!.length,
                          itemBuilder: (ctx, index) {
                            final form = state.surveyFormsList![index];
                            return Card(
                              margin: const EdgeInsets.all(8),
                              child: InkWell(
                                onTap: (UserStorage().userData!.isAdmin() || form.isSubmitted()) ? null : () async {
                                  _submitForm(form.id, form.title, form.questions);
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
                                      if (UserStorage().userData!.isNormalUser())
                                        FormStatus(status: form.formStatus!,)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),

                    if (UserStorage().userData!.isAdmin())
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
            }
    );
  }

}