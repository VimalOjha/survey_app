import 'package:flutter/material.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/features/home/survey/presentation/widgets/form_text_field_widget.dart';

class FormCardTypeTextWidget extends StatelessWidget {
  final String labelText ;
  final TextEditingController controllerQuestion;
  final TextEditingController controllerInstruction;
  final int index;

  const FormCardTypeTextWidget({super.key,
    this.labelText ='',
    required this.controllerQuestion,
    required this.controllerInstruction,
    required this.index});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormTextFieldWidget(
                labelText: '${AppStrings.labelEnterQuestion} ${index + 1}',
                controller: controllerQuestion
            ),

            const SizedBox(
              height: 12,
            ),
            FormTextFieldWidget(
                labelText:  AppStrings.labelEnterInstruction,
                controller: controllerInstruction
            ),
          ],
        ),
      ),
    );
  }
}