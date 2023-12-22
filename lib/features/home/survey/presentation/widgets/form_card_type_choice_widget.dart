import 'package:flutter/material.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';
import 'package:survey_app/features/home/survey/presentation/widgets/form_text_field_widget.dart';

class FormCardTypeChoiceWidget extends StatelessWidget {
  final String labelText ;
  final TextEditingController controller;
  final int index;
  final List<TextEditingController> optionsList;

  const FormCardTypeChoiceWidget({super.key, this.labelText ='',
    required this.controller,
    required this.index,
    required this.optionsList
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelText),
            const SizedBox(
              height: 12,
            ),

            FormTextFieldWidget(
                labelText:  '${AppStrings.labelEnterQuestion} ${index + 1}',
                controller: controller
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(AppStrings.labelEnterOptions),

            for (var i = 0; i < optionsList.length; i++) ...[
              FormTextFieldWidget(
                  labelText:  '${AppStrings.labelOption} ${i + 1}',
                  controller: optionsList[i]
              ),
              const SizedBox(
                height: 8,
              ),
            ]
          ],
        ),
      ),
    );
  }
}