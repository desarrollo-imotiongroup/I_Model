import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/center_management/administrator_controller.dart';
import 'package:i_model/view_models/center_management/beautician_controller.dart';
import 'package:i_model/view_models/center_management/create_profile_controller.dart';
import 'package:i_model/views/dialogs/create_file/create_file_dialog.dart';
import 'package:i_model/views/overlays/administrator_list_overlay.dart';
import 'package:i_model/views/overlays/beautician_list_overlay.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/menu_widget.dart';
import 'package:i_model/widgets/textview.dart';

class CenterManagementScreen extends StatelessWidget {
  CenterManagementScreen({super.key});

  final AdministratorController administratorController = Get.put(AdministratorController());
  final BeauticianController beauticianController = Get.put(BeauticianController());
  final CreateProfileController createProfileController = Get.put(CreateProfileController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        administratorController.disposeController();
        beauticianController.disposeController();
        createProfileController.disposeController();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage(Strings.bgImage))),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  // Ensures the Column takes the full height
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.06,
                      left: screenHeight * 0.1,
                      right: screenHeight * 0.04,
                      bottom: screenHeight * 0.07,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              administratorController.disposeController();
                              beauticianController.disposeController();
                              createProfileController.disposeController();
                              Navigator.pop(context);
                            },
                            child: Image(
                              image: AssetImage(
                                Strings.backIcon,
                              ),
                              height: screenHeight * 0.1,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// Center management
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView.title(
                                  translation(context).centerManagement.toUpperCase(),
                                  color: AppColors.pinkColor,
                                  isUnderLine: true,
                                  fontSize: 18.sp,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.07,
                                ),

                                /// Administrators
                                MenuWidget(
                                  title: translation(context).administrators.toUpperCase(),
                                  onTap: () {
                                    administratorListOverlay(context);
                                  },
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),

                                /// Beauticians list
                                MenuWidget(
                                  title: Strings.beauticians.toUpperCase(),
                                  onTap: () {
                                    beauticianListOverlay(context);
                                  },
                                ),

                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),

                                /// Create new
                                MenuWidget(
                                  title: translation(context).createNew.toUpperCase(),
                                  onTap: () {
                                    createFileDialog(context);
                                  },
                                )
                              ],
                            ),

                            /// logo_imodel
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenHeight * 0.1,
                                  right: screenWidth * 0.05),
                              child: imageWidget(
                                image: Strings.logoIModel,
                                height: screenHeight * 0.2,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
