import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/client/client_controller.dart';
import 'package:i_model/views/dialogs/client/client_file/client_active_groups.dart';
import 'package:i_model/views/dialogs/client/client_file/client_activities.dart';
import 'package:i_model/views/dialogs/client/client_file/client_bioimpedancia.dart';
import 'package:i_model/views/dialogs/client/client_file/client_card.dart';
import 'package:i_model/views/dialogs/client/client_file/client_personal_data.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/widgets/tab_header.dart';
import 'package:i_model/widgets/top_title_button.dart';

void clientFileDialog(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final ClientController controller = Get.put(ClientController());

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      controller.setClientName();

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
                    child: TopTitleButton(title: Strings.clientFile),
                  ),
                  Divider(color: AppColors.pinkColor),

                  // Tab Bar Implementation
                  DefaultTabController(
                    length: 5, // Number of tabs
                    child: Column(
                      children: [
                        TabHeader(tabs: [
                          Tab(text: Strings.personalData.toUpperCase()),
                          Tab(text: Strings.activities.toUpperCase()),
                          Tab(text: Strings.cards.toUpperCase()),
                          Tab(text: Strings.bioimpedancia.toUpperCase()),
                          Tab(text: Strings.activeGroups.toUpperCase()),
                        ],),
                        SizedBox(
                          height: screenHeight * 0.7,
                          child: TabBarView(
                            children: [
                              /// Personal Data content
                              ClientPersonalData(),

                              /// Activities content
                              ClientActivities(),

                              /// Cards/bonos content
                              ClientCard(),

                              /// Bioimpedancia content
                              ClientBioimpedancia(),

                              /// Content for Grupos Activos
                              ClientActiveGroups(),
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
