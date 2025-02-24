import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/image_widget.dart';

import 'textview.dart';

class MciWidget extends StatelessWidget {
  final String? icon;
  final String mciName;
  final String mciId;
  final Color? barColor;
  final bool isConnected;
  final bool isSelected;
  final bool isUpdated;
  final int? batteryStatus;

  const MciWidget({
    this.icon,
    required this.mciName,
    required this.mciId,
    this.barColor,
    this.isConnected = false,
    this.isSelected = false,
    this.isUpdated = false,
    this.batteryStatus,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return  Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.005),
      child: RoundedContainer(
        borderColor: isConnected ? Colors.pink : AppColors.darkGrey2,
        borderWidth: isSelected ? 3 : 1,
          padding: EdgeInsets.only(
              top: screenWidth * 0.0,
              left: screenHeight * 0.008,
              bottom: screenHeight *  0.005
          ),
          width: screenWidth * 0.15,
          borderRadius: screenHeight * 0.02,
          widget: Row(
            children: [
              imageWidget(
                  image: icon ?? Strings.suitIcon,
                  height: screenHeight * 0.06
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextView.title(
                      mciName.toUpperCase(),
                      fontSize: 9.sp,
                      color: AppColors.blackColor.withValues(alpha: 0.7)
                  ),
                  SizedBox(height: screenHeight * 0.005,),
                  TextView.title(
                      mciId,
                      fontSize: 8.sp,
                      color: AppColors.blackColor.withValues(alpha: 0.7)
                  ),
                  SizedBox(height: screenHeight * 0.005,),
                  SizedBox(
                    height: screenHeight * 0.01,
                    width: screenWidth * 0.1,
                    child: isConnected
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                      List.generate(
                        5,
                            (batteryIndex) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * 0.001),
                            child:
                            Container(
                              width: MediaQuery.of(context).size.width * 0.015,
                              height: MediaQuery.of(context).size.height * 0.015,
                              color: batteryIndex <= (batteryStatus ?? -1)
                                  ? _lineColor(batteryStatus!)
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          );
                        },
                      ),
                    )
                    : SizedBox(),

                    // ListView.builder(
                    //   padding: EdgeInsets.zero,
                    //   scrollDirection: Axis.horizontal, // Horizontal scrolling
                    //   itemCount: 5,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return Padding(
                    //       padding: EdgeInsets.only(left: screenWidth * 0.005),
                    //       child: BarContainer(
                    //         width: screenWidth * 0.015,
                    //         color: barColor ?? AppColors.greyColor,
                    //       ),
                    //     );
                    //   },
                    // ),
                  )
                ],
              )
            ],
          )
      ),
    );

  }
}

Color _lineColor(int battery) {
  // Obtener el estado de la batería de la dirección MAC proporcionada
  final int? batteryStatus = battery;
  // final int? batteryStatus = batteryStatuses[macAddress];
  // Determinar el color basado en el estado de la batería
  switch (batteryStatus) {
    case 0: // Muy baja
      return Colors.red;
    case 1: // Baja
      return Colors.orange;
    case 2: // Media
      return Colors.yellow;
    case 3: // Alta
      return Colors.lightGreenAccent;
    case 4: // Llena
      return Colors.green;
    default: // Desconocido o no disponible
      return Colors.transparent;
  }
}
