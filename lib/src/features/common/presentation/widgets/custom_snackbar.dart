import 'package:flutter/material.dart';

class CustomSnackbar {
  final BuildContext context;

  CustomSnackbar(this.context);
  void show({required String message, bool isError = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: isError ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(message, style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.background,
                  fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
        duration: const  Duration(seconds: 1, milliseconds: 5),
      ),
    );
  }
}