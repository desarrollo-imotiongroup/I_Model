import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/client/create_new_client_controller.dart';
import 'package:i_model/views/dialogs/client/create_new_client/create_client_active_groups.dart';
import 'package:i_model/views/dialogs/client/create_new_client/create_client_card.dart';
import 'package:i_model/views/dialogs/client/create_new_client/create_client_personal_data.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/widgets/no_entry_widget.dart';
import 'package:i_model/widgets/tab_header.dart';
import 'package:i_model/widgets/top_title_button.dart';

void createNewClientDialog(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  CreateNewClientController controller = Get.put(CreateNewClientController());


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
                    child: TopTitleButton(title: translation(context).createNewClient, onCancel: (){
                      controller.resetEverything();
                      Navigator.pop(context);
                    },),
                  ),
                  Divider(color: AppColors.pinkColor),

                  // Tab Bar Implementation
                  DefaultTabController(
                    length: 3, // Number of tabs
                    child: Column(
                      children: [
                        TabHeader(tabs: [
                          Tab(text: translation(context).personalData.toUpperCase()),
                          Tab(text: translation(context).cards.toUpperCase()),
                          Tab(text: translation(context).activeGroups.toUpperCase()),
                        ],),
                           Obx(() =>
                               SizedBox(
                                 height: screenHeight * 0.7,
                                 child: TabBarView(
                                   children: [
                                     /// Personal Data content
                                     CreateClientPersonalData(),

                                     /// Cards/bonos content
                                     controller.isDataSaved.value
                                     ? CreateClientCard()
                                     : noEntryToTab(context, title: translation(context).noEntryToBonos),

                                     /// Content for Grupos Activos
                                     controller.isDataSaved.value
                                     ? CreateClientActiveGroups()
                                     : noEntryToTab(context, title: translation(context).noEntryToActiveGroups)
                                   ],
                                 ),
                               ),
                           )



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
