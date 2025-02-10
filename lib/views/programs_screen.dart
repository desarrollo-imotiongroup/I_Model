import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/programs_controller.dart';
import 'package:i_model/views/dialogs/create_program/create_program_dialog.dart';
import 'package:i_model/views/overlays/automatic_program_overlay.dart';
import 'package:i_model/views/overlays/individual_programs_overlay.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/menu_widget.dart';
import 'package:i_model/widgets/textview.dart';

class ProgramsScreen extends StatelessWidget {
  ProgramsScreen({super.key});

  final ProgramsController programsController = Get.put(ProgramsController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                      Strings.bgImage
                  )
              )
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight( // Ensures the Column takes the full height
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight  * 0.06,
                    left: screenHeight  * 0.1,
                    right: screenHeight  * 0.04,
                    bottom: screenHeight  * 0.07,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: (){
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
                      SizedBox(height: screenHeight * 0.05,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Programs
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextView.title(
                                  translation(context).programs.toUpperCase(),
                                  color: AppColors.pinkColor,
                                  isUnderLine: true,
                                  fontSize: 18.sp
                              ),
                              SizedBox(height: screenHeight *  0.07,),

                              /// Individuals
                              MenuWidget(
                                title: translation(context).individuals.toUpperCase(),
                                onTap: (){
                                  individualProgramsOverlay(context);
                                },
                              ),
                              SizedBox(height: screenHeight * 0.01,),

                              /// Automatics
                              MenuWidget(
                                title: Strings.automatics.toUpperCase(),
                                onTap: (){
                                  automaticProgramOverlay(
                                      context,
                                      programList: programsController.automaticProgramsList
                                  );
                                },
                              ),

                              SizedBox(height: screenHeight * 0.01,),

                              /// Create program
                              MenuWidget(
                                title: translation(context).createProgram.toUpperCase(),
                                onTap: (){
                                  createProgramDialog(context);
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
                              image:  Strings.logoIModel,
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
          )
      ),
    );
  }
}
