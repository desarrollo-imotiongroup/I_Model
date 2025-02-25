import 'package:flutter/material.dart';
import 'package:i_model/views/dashboard/first_column.dart';
import 'package:i_model/views/dashboard/fourth_column.dart';
import 'package:i_model/views/dashboard/second_column.dart';
import 'package:i_model/views/dashboard/third_column.dart';

class ExpandedPanelView extends StatelessWidget {
  final int index;

  const ExpandedPanelView({
    required this.index,
    super.key});



  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Muscle group - first column
        DashboardFirstColumn(index: index),
        SizedBox(width: screenWidth * 0.01,),

        /// Second column - timer
        DashboardSecondColumn(index: index),
        SizedBox(width: screenWidth * 0.027,),

        /// Muscle group 2 - third column
        DashboardThirdColumn(),
        SizedBox(width: screenWidth * 0.03,),

        /// Fourth column, contraction, pause, reset
        DashboardFourthColumn()
      ],
    );
  }
}
