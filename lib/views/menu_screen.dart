import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textview.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    Widget menuWidget({Function()? onTap, required String title}){
      return  GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
              bottom: screenHeight * 0.02,
              left: screenWidth * 0.05
          ),
          width: screenWidth * 0.24,
          height: screenHeight * 0.1,
          child: Card(
            color: AppColors.pureWhiteColor,
            elevation: 5,
            shadowColor: AppColors.pureWhiteColor,
            child: Center(
              child: TextView.title(
                  title,
                  color: AppColors.pinkColor,
                  fontSize: 14.sp
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                Strings.bgImage,
              ),
            fit: BoxFit.cover
          )
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight  * 0.07,
            left: screenHeight  * 0.1,
            right: screenHeight  * 0.04,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Image(
                  image: AssetImage(
                    Strings.ignitionIcon,
                  ),
                  height: screenHeight * 0.1,
                ),
              ),
              SizedBox(height: screenHeight * 0.01,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Menu list
                 Column(
                   children: [
                     menuWidget(title: Strings.controlPanel),
                     menuWidget(title: Strings.clients),
                     menuWidget(title: Strings.programs),
                     menuWidget(title: Strings.biompedancia),
                     menuWidget(title: Strings.tutorials),
                     menuWidget(title: Strings.adjusts),
                   ],
                 ),
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.05),
                    child: imageWidget(
                      image:  Strings.logoIModel,
                      height: screenHeight * 0.2,
                    ),
                  )

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
