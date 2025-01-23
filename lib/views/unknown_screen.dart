import 'package:flutter/material.dart';
import 'package:i_model/core/strings.dart';

class UnKnownScreen extends StatelessWidget {
  const UnKnownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(Strings.unknownError),
      ),
    );
  }
}
