import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/views/dashboard/first_column.dart';
import 'package:i_model/views/dashboard/fourth_column.dart';
import 'package:i_model/views/dashboard/second_column.dart';
import 'package:i_model/views/dashboard/third_column.dart';
import 'package:i_model/widgets/mci_widget.dart';


class DashboardScreen extends StatelessWidget
{DashboardScreen({super.key});

 final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.offWhite
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.035,
            left: screenWidth * 0.03,
            right: screenWidth * 0.02,
          ),
          child: Column(
            children: [
              /// MCI Containers
              Container(
                color: AppColors.seperatorColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() =>
                        Row(
                          children: [
                            MciWidget(
                              mciName: controller.selectedClient.value == ''
                                  ? Strings.mciNames[0]
                                  : controller.selectedClient.value,
                              mciId: Strings.mciIDs[0],
                            ),
                            MciWidget(
                              mciName: Strings.mciNames[1],
                              mciId: Strings.mciIDs[1],
                            ),
                            MciWidget(
                              icon: Strings.selectedSuitIcon,
                              mciName: Strings.mciNames[2],
                              mciId: Strings.mciIDs[2],
                            ),
                          ],
                        ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image(
                        image: AssetImage(
                          Strings.backIcon,
                        ),
                        height: screenHeight * 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Muscle group  - first column
                  DashboardFirstColumn(),
                  SizedBox(width: screenWidth * 0.01,),

                  /// Second column - timer
                  DashboardSecondColumn(),
                  SizedBox(width: screenWidth * 0.03,),

                  /// Muscle group 2 - third column
                  DashboardThirdColumn(),
                  SizedBox(width: screenWidth * 0.03,),

                  /// Fourth column, contraction, pause, reset
                  DashboardFourthColumn()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
