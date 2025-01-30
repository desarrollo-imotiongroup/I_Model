import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/constants.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/program.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textview.dart';

void programListOverlay(
    BuildContext context,{
      required List<Program> programList,
    }) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final DashboardController controller = Get.put(DashboardController());

  overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.85, // Ensure overlay height remains fixed
          decoration: BoxDecoration(
            color: AppColors.pureWhiteColor,
            borderRadius: BorderRadius.circular(screenHeight * 0.02),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Fixed shadow issue
                spreadRadius: 3,
                blurRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: screenWidth * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.005),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: TextView.title(
                          Strings.selectProgram.toUpperCase(),
                          isUnderLine: true,
                          color: AppColors.pinkColor,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (overlayEntry.mounted) {
                          overlayEntry.remove();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.015),
                        child: Icon(
                          Icons.close_sharp,
                          size: screenHeight * 0.04,
                          color: AppColors.blackColor.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(color: AppColors.pinkColor),

              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  itemCount: programList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 1.4,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        controller.setProgramDetails(
                            name: programList[index].name,
                            image: programList[index].image
                        );
                        if (overlayEntry.mounted) {
                          overlayEntry.remove();
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextView.title(
                            programList[index].name,
                            fontSize: 14.sp,
                            color: AppColors.blackColor.withOpacity(0.8),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          imageWidget(
                            image: programList[index].image,
                            height: screenHeight * 0.15,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);
}

