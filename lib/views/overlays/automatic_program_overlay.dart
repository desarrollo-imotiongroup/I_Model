import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/models/program.dart';
import 'package:i_model/models/programs/automatic/automatic_program.dart';
import 'package:i_model/view_models/programs_controller.dart';
import 'package:i_model/views/dialogs/selected_auto_program_dialog.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textview.dart';
import 'package:i_model/widgets/top_title_button.dart';

void automaticProgramOverlay(
    BuildContext context,{
      required List<AutomaticProgramModel> programList,
    }) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final ProgramsController controller = Get.put(ProgramsController());
  controller.onInit();

  overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.85,
          decoration: boxDecoration(context),
          child: Column(
            children: [
              SizedBox(height: screenWidth * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: TopTitleButton(
                  title: translation(context).selectProgram,
                  onCancel: (){
                    if (overlayEntry.mounted) {
                      overlayEntry.remove();
                    }
                  },
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
                        // automaticProgramsList[0]['subprogramas'][0]['nombre']

                        print('SubPrograms: ${controller.automaticProgramsList[index]}');

                        selectedAutomaticProgramDialog(context,
                            selectedProgramData: controller.automaticProgramsList[index]
                        );

                        if (overlayEntry.mounted) {
                          overlayEntry.remove();
                        }

                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextView.title(
                            programList[index].name.toUpperCase(),
                            fontSize: 13.sp,
                            color: AppColors.blackColor.withValues(alpha: 0.8),
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

