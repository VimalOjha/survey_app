
import 'package:flutter/material.dart';
import 'package:survey_app/configs/utilities/constants/app_strings.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(AppStrings.labelProgressLoading),
      ),
    );
  }

}