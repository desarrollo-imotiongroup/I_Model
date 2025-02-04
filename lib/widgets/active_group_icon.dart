import 'package:flutter/material.dart';

class ActiveGroupIcon extends StatelessWidget {
  final String icon;
  final bool isChecked;

  const ActiveGroupIcon(
      {required this.icon, required this.isChecked, super.key});

  @override
  Widget build(BuildContext context) {
    return isChecked
        ? Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(icon),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
        : Container();
  }
}
