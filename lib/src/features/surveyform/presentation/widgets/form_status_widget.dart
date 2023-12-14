import 'package:flutter/material.dart';
import 'package:survey_app/src/utils/commons/constants/enums/survey_status.dart';


class FormStatus extends StatefulWidget {
  const FormStatus({super.key, required this.status});
  final String status;
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

}