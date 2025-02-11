import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/textview.dart';

class TechnicalSupport extends StatelessWidget {
  final Function()? onCancel;

  const TechnicalSupport({this.onCancel, super.key});


  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    technicalSupportWidget({Function()? onTap, required String title}){
      return Padding(
        padding: EdgeInsets.only(
            right: screenWidth * 0.01
        ),
        child: SizedBox(
          height: screenHeight * 0.15,
          width: screenWidth * 0.15,
          child: RoundedContainer(
            onTap: onTap,
              borderColor: AppColors.darkGrey,
              widget: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02
                ),
                child: TextView.title(
                    title,
                    fontSize: 13.sp,
                    lines: 2,
                    color: AppColors.pinkColor,
                    textAlign: TextAlign.center
                ),
              )
          ),
        ),
      );
    }


    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.05),
      width: screenWidth * 0.52,
      height: screenHeight * 0.5,
      decoration: BoxDecoration(
        color: AppColors.pureWhiteColor,
        borderRadius: BorderRadius.circular(screenHeight * 0.02),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3), // Shadow color
            spreadRadius: 3, // How wide the shadow spreads
            blurRadius: 2, // The blur effect
            offset: Offset(0, 3), // Changes position of shadow (x, y)
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: screenWidth * 0.01,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.01),
                      child: TextView.title(
                        Strings.technicalSupport.toUpperCase(),
                        isUnderLine: true,
                        color: AppColors.pinkColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onCancel,
                child: Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.015),
                    child: Icon(
                      Icons.close_sharp,
                      size: screenHeight * 0.04,
                      color: AppColors.blackColor.withValues(alpha: 0.8),
                    )),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              left: screenWidth * 0.01,
              right: screenWidth * 0.01,
              top: screenHeight * 0.002,
            ),
            child: Divider(
              color: AppColors.pinkColor,
            ),
          ),
         Expanded(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   technicalSupportWidget(title: Strings.importClient),
                   technicalSupportWidget(title: Strings.reloadPrograms),
                   technicalSupportWidget(title: Strings.reloadMCI18000),
                 ],
               ),
               SizedBox(height: screenHeight * 0.02,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   technicalSupportWidget(title: Strings.searchMybodypro),
                   technicalSupportWidget(title: Strings.timeTo100),
                 ],
               )
             ],
           ),
         )
        ],
      ),
    );
  }
}
