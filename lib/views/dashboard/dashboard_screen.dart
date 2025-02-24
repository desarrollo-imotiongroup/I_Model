import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/app_state.dart';
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
                  Obx(() =>
                      Container(
                        color: AppColors.seperatorColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ListView.builder wrapped with Obx to make the list reactive

                            dashboardController.newMacAddresses.isEmpty
                                ? Center(child: Text("No devices available"))
                                : dashboardController.isLoading.value
                                ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.pinkColor,
                              ),
                            )
                                : SizedBox(
                              height: screenHeight * 0.1,  // Set fixed height for ListView
                              width: screenWidth * 0.8,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: dashboardController.newMacAddresses.length,
                                itemBuilder: (context, index) {
                                  final mciName = clientController.selectedClientName.value.isEmpty
                                      ? Strings.nothing
                                      : clientController.selectedClientName.value;

                                  dashboardController.isUpdate.value;

                                  return GestureDetector(
                                      onTap: () async {
                                          dashboardController.selectedDeviceIndex.value = index;
                                          await dashboardController.selectDevice(dashboardController.newMacAddresses[index]);
                                          dashboardController.selectedMacAddress.value = dashboardController.newMacAddresses[index];
                                      },
                                      child:Obx(() =>
                                          MciWidget(
                                            isUpdated: dashboardController.isUpdate.value,
                                            mciName: mciName,
                                            mciId: (dashboardController.bluetoothNames[dashboardController.newMacAddresses[index]]) ?? '',
                                            batteryStatus: dashboardController.batteryStatuses[dashboardController.newMacAddresses[index]],
                                            isConnected: dashboardController.deviceConnectionStatus[dashboardController.newMacAddresses[index]] == 'desconectado'
                                                ? false
                                                : true,
                                            isSelected: (dashboardController.selectedDeviceIndex.value == index
                                                && (dashboardController.deviceConnectionStatus[dashboardController.newMacAddresses[index]] == 'conectado'
                                                   || dashboardController.deviceConnectionStatus[dashboardController.newMacAddresses[index]] == 'connected'))
                                                ? true  // Set border width when selected
                                                : false,

                                          ),
                                      )

                                  );
                                },
                              ),
                            ),


                            // GestureDetector for handling back button
                            GestureDetector(
                              onTap: () {
                                closePanel(context);  // Handle the back button tap
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Image(
                                  image: AssetImage(Strings.backIcon),
                                  height: screenHeight * 0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                  Row(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
