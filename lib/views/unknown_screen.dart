import 'package:flutter/material.dart';
import 'package:i_model/config/language_constants.dart';

class UnKnownScreen extends StatelessWidget {
  const UnKnownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(translation(context).unknownError),
      ),
    );
  }
}
