import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/client/client_controller.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/views/dashboard/first_column.dart';
import 'package:i_model/views/dashboard/fourth_column.dart';
import 'package:i_model/views/dashboard/second_column.dart';
import 'package:i_model/views/dashboard/third_column.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';
import 'package:i_model/widgets/mci_widget.dart';


class DashboardScreen extends StatelessWidget
{DashboardScreen({super.key});

 final DashboardController dashboardController = Get.put(DashboardController());
 final ClientController clientController = Get.put(ClientController());

 void closePanel(BuildContext context){
   alertOverlay(context,
       heading: translation(context).warning,
       description: translation(context).exitFromPanel,
       buttonText: translation(context).yesDelete,
       onPress: () {
         dashboardController.resetEverything();
         Navigator.pushNamedAndRemoveUntil(
           context,
           Strings.menuScreen, (route) => false,
         );
       });
 }

  @override
  Widget build(BuildContext context) {
    dashboardController.onInit();
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        closePanel(context);
      },
      child: Scaffold(
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
              right: screenWidth * 0.015,
            ),
            child: SingleChildScrollView(
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
                                  mciName: clientController.selectedClientName.value == ''
                                      ? Strings.mciNames[0]
                                      : clientController.selectedClientName.value,
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
                            closePanel(context);
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
                      SizedBox(width: screenWidth * 0.027,),

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
        ),
      ),
    );
  }
}
