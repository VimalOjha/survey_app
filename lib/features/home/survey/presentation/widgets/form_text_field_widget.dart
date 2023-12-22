import 'package:flutter/material.dart';

class FormTextFieldWidget extends StatelessWidget {
  final String labelText ;
  final TextEditingController controller;

  const FormTextFieldWidget({super.key, this.labelText ='', required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration:  InputDecoration(
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.normal
            )
        ),
        controller: controller,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.normal
        )
    );
  }
}