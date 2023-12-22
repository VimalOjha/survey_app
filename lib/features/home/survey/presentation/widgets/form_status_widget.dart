import 'package:flutter/material.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/configs/utilities/constants/enums/survey_status.dart';

class FormStatus extends StatelessWidget {
  const FormStatus({super.key, this.status = AppStrings.labelPending});
  final String status ;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color:
        status.toLowerCase() == SurveyStatus.submitted.name
            ? Colors.green
            : Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style:
        const TextStyle(color: Colors.white),
      ),
    );
  }
}