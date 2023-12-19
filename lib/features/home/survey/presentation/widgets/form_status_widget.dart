import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/configs/utilities/constants/enums/survey_status.dart';
import 'package:survey_app/features/home/survey/application/survey_form_bloc.dart';
import 'package:survey_app/features/home/survey/application/survey_form_state.dart';

class FormStatus extends StatefulWidget {
  FormStatus({super.key, required this.status});
  String status = AppStrings.labelPending;
  @override
  State<FormStatus> createState() {
    return _FormStatusState();
  }
}
class _FormStatusState extends State<FormStatus> {
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyFormBloc, SurveyFormState>(
        builder: (context, state) {
          if(state is SurveyFormsStatusChanged){
            widget.status = state.newStatus;
          }
          return Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color:
              widget.status == SurveyStatus.SUBMITTED.name
                  ? Colors.green
                  : Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.status,
              style:
              const TextStyle(color: Colors.white),
            ),
          );
        }
    );
  }

}