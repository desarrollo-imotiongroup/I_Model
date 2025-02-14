import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/view_models/client/create_new_client_controller.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';
import 'package:i_model/widgets/top_title_button.dart';

void buyPointsOverlay(
  BuildContext context, {
  required TextEditingController textEditingController,
  required Function() onAdd,
}) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  CreateNewClientController controller = Get.put(CreateNewClientController());

  overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Container(
          width: screenWidth * 0.4,
          height: screenHeight * 0.4,
          decoration: boxDecoration(context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenWidth * 0.015),
                  TopTitleButton(
                    title: translation(context).buyPoints,
                    onCancel: () {
                      if (overlayEntry.mounted) {
                        overlayEntry.remove();
                      }
                    },
                  ),
                  Divider(color: AppColors.pinkColor),
                  SizedBox(
                    height: screenHeight * 0.015,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: Column(
                      children: [
                        TextFieldLabel(
                          label: translation(context).pointsQuantity,
                          width: screenWidth * 0.33,
                          textEditingController: textEditingController,
                          isAllowNumberOnly: true,
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        RoundedContainer(
                            onTap: (){
                              if(textEditingController.text.isEmpty){
                                alertOverlay(context,
                                  heading: translation(context).alertCompleteForm,
                                  headingColor: AppColors.darkRedColor,
                                  description: translation(context).emptyPointsError,
                                  isOneButtonNeeded: true,
                                );
                              }
                              else {
                                if (overlayEntry.mounted) {
                                  overlayEntry.remove();
                                }
                                onAdd();
                              }
                            },
                            borderRadius: screenHeight * 0.01,
                            width: screenWidth * 0.1,
                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.013),
                            widget: TextView.title(translation(context).add.toUpperCase(),
                                fontSize: 12.sp,
                                color: AppColors.blackColor.withValues(alpha: 0.8)))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);
}
