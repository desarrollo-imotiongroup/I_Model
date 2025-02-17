import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/programs_controller.dart';
import 'package:i_model/views/dialogs/create_program/automatic/automatic_program.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/views/dialogs/create_program/individual/active_groups.dart';
import 'package:i_model/views/dialogs/create_program/individual/configuration.dart';
import 'package:i_model/views/dialogs/create_program/individual/cronaxia.dart';
import 'package:i_model/widgets/tab_header.dart';
import 'package:i_model/widgets/textview.dart';
import 'package:i_model/widgets/top_title_button.dart';

void createProgramDialog(BuildContext context,) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;

  ProgramsController controller = Get.put(ProgramsController());

  Widget noConfigurationDataSavedMsg({bool isCronaxia = true}){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.15
      ),
      child: Center(
        child: TextView.title(
            isCronaxia
                ? Strings.noEntryToCronaxia.toUpperCase()
                : Strings.noEntryToActiveGroups.toUpperCase(),
            fontSize: 10.sp,
            lines: 2,
            textAlign: TextAlign.center,
            color: AppColors.blackColor.withValues(alpha: 0.8)
        ),
      ),
    );
  }

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.9,
          decoration: boxDecoration(context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenWidth * 0.015),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: screenWidth * 0.005),
                    child: TopTitleButton(
                      title:  translation(context).createProgram, onCancel: (){
                      controller.resetEverything();
                      Navigator.pop(context);
                    },),
                  ),
                  Divider(color: AppColors.pinkColor),

                  // Tab Bar Implementation
                  DefaultTabController(
                    length: 2, // Number of tabs
                    child: Column(
                      children: [
                        TabHeader(tabs: [
                          Tab(text: translation(context).individual.toUpperCase()),
                          Tab(text: translation(context).automatics.toUpperCase()),
                        ],),
                        SizedBox(
                          height: screenHeight * 0.7,
                          child: TabBarView(
                            children: [
                              /// Individual
                              DefaultTabController(
                                length: 3, // Number of tabs
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TabHeader(
                                        width: screenWidth * 0.5,
                                        bgColor: AppColors.pureWhiteColor,
                                        unSelectedColor: AppColors.blackColor,
                                        tabs: [
                                        Tab(text: translation(context).configurationTab.toUpperCase()),
                                        Tab(text: translation(context).cronaxiaTab.toUpperCase()),
                                        Tab(text: translation(context).activeGroups.toUpperCase()),
                                      ],),
                                    ),
                                    Obx(() =>
                                        SizedBox(
                                          height: screenHeight * 0.6,
                                          child: TabBarView(
                                            children: [
                                              /// Configuration
                                              Configuration(),

                                              /// Cronaxia
                                              controller.isConfigurationSaved.value
                                                  ? Cronaxia()
                                                  : noConfigurationDataSavedMsg(),

                                              /// Active groups
                                              controller.isConfigurationSaved.value
                                                  ? ActiveGroups()
                                                  : noConfigurationDataSavedMsg(isCronaxia: false),
                                            ],
                                          ),
                                        ),
                                    )

                                  ],
                                ),
                              ),
                              /// Automatics
                              SizedBox(
                                height: screenHeight * 0.6,
                                child: AutomaticProgram(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
