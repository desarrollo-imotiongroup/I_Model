import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/center_management/beautician_controller.dart';
import 'package:i_model/views/dialog/beautician_file/beautician_activities.dart';
import 'package:i_model/views/dialog/beautician_file/beautician_card.dart';
import 'package:i_model/views/dialog/beautician_file/beautician_personal_data.dart';
import 'package:i_model/widgets/overlay/box_decoration.dart';
import 'package:i_model/widgets/overlay/tab_header.dart';
import 'package:i_model/widgets/overlay/top_title_button.dart';


void beauticianFileDialog(BuildContext context,) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final BeauticianController controller = Get.put(BeauticianController());

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      controller.setInitialNickName();

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
                    child: TopTitleButton(title: Strings.beauticianFile),
                  ),
                  Divider(color: AppColors.pinkColor),

                  // Tab Bar Implementation
                  DefaultTabController(
                    length: 3, // Number of tabs
                    child: Column(
                      children: [
                        TabHeader(
                          tabs: [
                          Tab(text: Strings.personalData.toUpperCase()),
                          Tab(text: Strings.cards.toUpperCase()),
                          Tab(text: Strings.activities.toUpperCase()),
                        ],),
                        SizedBox(
                          height: screenHeight * 0.7,
                          child: TabBarView(
                            children: [
                              /// Personal Data content
                              BeauticianPersonalData(),

                              /// Cards/bonos content
                              BeauticianCard(),

                              /// Activities content
                              BeauticianActivities()


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
