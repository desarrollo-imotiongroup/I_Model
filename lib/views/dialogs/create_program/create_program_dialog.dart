import 'package:flutter/material.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/views/dialogs/create_program/automatic/automatic_program.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/views/dialogs/create_program/individual/active_groups.dart';
import 'package:i_model/views/dialogs/create_program/individual/configuration.dart';
import 'package:i_model/views/dialogs/create_program/individual/cronaxia.dart';
import 'package:i_model/widgets/tab_header.dart';
import 'package:i_model/widgets/top_title_button.dart';

void createProgramDialog(BuildContext context,) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;


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
                    child: TopTitleButton(title:  Strings.createProgram),
                  ),
                  Divider(color: AppColors.pinkColor),

                  // Tab Bar Implementation
                  DefaultTabController(
                    length: 2, // Number of tabs
                    child: Column(
                      children: [
                        TabHeader(tabs: [
                          Tab(text: Strings.individual.toUpperCase()),
                          Tab(text: Strings.automatics.toUpperCase()),
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
                                        Tab(text: Strings.configurationTab.toUpperCase()),
                                        Tab(text: Strings.cronaxiaTab.toUpperCase()),
                                        Tab(text: Strings.activeGroups.toUpperCase()),
                                      ],),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.6,
                                      child: TabBarView(
                                        children: [
                                          /// Configuration
                                           Configuration(),

                                          /// Cronaxia
                                          Cronaxia(),

                                          /// Active groups
                                          ActiveGroups()
                                        ],
                                      ),
                                    ),
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
