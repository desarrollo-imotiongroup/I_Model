import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/containers/box_container.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'textview.dart';

class MciWidget extends StatelessWidget {
  final String? icon;
  final String mciName;
  final String mciId;
  final Color? barColor;



  const MciWidget({
    this.icon,
    required this.mciName,
    required this.mciId,
    this.barColor,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return  Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.005),
      child: RoundedContainer(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal, // Horizontal scrolling
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.005),
                          child: BarContainer(
                            width: screenWidth * 0.018,
                            color: barColor ?? AppColors.greenColor,
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          )
      ),
    );

  }
}
