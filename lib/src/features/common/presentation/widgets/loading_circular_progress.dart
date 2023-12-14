
import 'package:flutter/material.dart';

class LoadingCircular extends StatelessWidget{
  const LoadingCircular({super.key, this.label = ''});
   final String label;
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 5,),
          Text(label)
        ],
      ),
    );
  }

}