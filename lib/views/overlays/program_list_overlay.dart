import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/program.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/widgets/top_title_button.dart';
import 'package:i_model/widgets/textview.dart';

void programListOverlay(
    BuildContext context,{
      required List<dynamic> programList,
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
          height: screenHeight * 0.85, // Ensure overlays height remains fixed
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
                        controller.selectedProgramDetails.value = programList[index];
                        // print('AUTOGROUP:  ${controller.selectedProgramDetails}');
                        controller.setProgramDetails(
                            programName: programList[index]['nombre'],
                            image: programList[index]['imagen'],
                            mainProgramName: programList[index]['nombre']
                        );

                        controller.resetProgramTimerValue();

                        if(controller.selectedProgramType.value == Strings.individual){
                          controller.contractionSeconds.value =  (programList[index]['contraccion']).toInt();
                          controller.pauseSeconds.value = programList[index]['pausa'].toInt();
                          controller.frequency.value = programList[index]['frecuencia'].toInt();
                          if(programList[index]['pulso'] == 'CX'){
                            controller.pulse.value = 0;
                          }
                          else{
                            controller.pulse.value = programList[index]['pulso'].toInt();
                          }
                        }
                        else{
                          controller.contractionSeconds.value =  0;
                          controller.pauseSeconds.value = 0;

                          for(int i=0; i<programList[index]['subprogramas'].length; i++){
                            controller.automaticProgramValues.add(
                              {
                              'subProgramName' : programList[index]['subprogramas'][i]['nombre'],
                              'duration' : programList[index]['subprogramas'][i]['duracion'],
                              'image' : programList[index]['subprogramas'][i]['imagen'],
                              'frequency' : programList[index]['subprogramas'][i]['frecuencia'],
                              'pulse' : programList[index]['subprogramas'][i]['pulso'] == 'CX'
                                ? 0
                                : programList[index]['subprogramas'][i]['pulso'],
                              'contraction' : programList[index]['subprogramas'][i]['contraccion'],
                              'pause' : programList[index]['subprogramas'][i]['pausa'],
                              }
                            );

                          }
                          controller.onAutoProgramSelected(programList[index]);

                          // controller.contractionSeconds.value =  programList[index]['subprogramas'][0]['contraccion'].toInt();
                          // controller.pauseSeconds.value = (programList[index]['subprogramas'][0]['pausa']).toInt();
                          // controller.frequency.value =  programList[index]['subprogramas'][0]['frecuencia'].toInt();
                          // controller.pauseSeconds.value = (programList[index]['subprogramas'][0]['pulso']).toInt();

                          // print('controller.automaticProgramValues: ${controller.automaticProgramValues}');
                        }

                        if (overlayEntry.mounted) {
                          overlayEntry.remove();
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextView.title(
                            programList[index]['nombre'].toUpperCase(),
                            fontSize: 13.sp,
                            color: AppColors.blackColor.withValues(alpha: 0.8),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          imageWidget(
                            image: programList[index]['imagen'],
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

///   if(selectedProgram == Strings.individual){
//       frecuencia = selectedProgramDetails['frecuencia'];
//       rampa = selectedProgramDetails['rampa'];
//       pulso = selectedProgramDetails['pulso'] == 'CX' ? 0.0 : selectedProgramDetails['pulso'];
//       pause = selectedProgramDetails['pausa'];
//       contraction = contractionSeconds.value.toDouble();
//
//       cronaxias = selectedProgramDetails['cronaxias'];
//       grupos = selectedProgramDetails['grupos_musculares'];
//     }
//
//     if(selectedProgram == Strings.automatics) {
//       for (var autoProgram in automaticProgramValues) {
//         frecuencia = autoProgram['frequency'];
//         rampa = autoProgram['rampa'];
//         pulso = autoProgram['pulse'] == 'CX' ? 0.0 : autoProgram['pulso'];
//         pause = autoProgram['pause'];
//         contraction = autoProgram['contraction'];
//       }
//       cronaxias = cronaxiasNotifier;
//       grupos = gruposMuscularesNotifier;
//     }