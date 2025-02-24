import 'package:flutter/material.dart';
import 'package:i_model/views/dashboard/first_column.dart';
import 'package:i_model/views/dashboard/fourth_column.dart';
import 'package:i_model/views/dashboard/second_column.dart';
import 'package:i_model/views/dashboard/third_column.dart';

class ExpandedPanelView extends StatefulWidget {
  final int index;
  final String macAddress;
  final String selectedKey;

  const ExpandedPanelView({
    required this.index,
    required this.macAddress,
    required this.selectedKey,
    super.key});

  @override
  State<ExpandedPanelView> createState() => _ExpandedPanelViewState();
}

class _ExpandedPanelViewState extends State<ExpandedPanelView> {


  @override
  Widget build(BuildContext context) {
    print('MACADDRESS: ${widget.macAddress}');
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Muscle group - first column
        DashboardFirstColumn(),
        SizedBox(width: screenWidth * 0.01,),

        /// Second column - timer
        DashboardSecondColumn(),
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
