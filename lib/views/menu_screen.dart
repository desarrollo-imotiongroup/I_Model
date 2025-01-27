import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/views/menu_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textview.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  Strings.bgImage,
                ),
                fit: BoxFit.cover)),
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.07,
            left: screenHeight * 0.1,
            right: screenHeight * 0.04,
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
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Menu list
                  Column(
                    children: [
                      MenuWidget(
                        title: translation(context).controlPanel,
                        onTap: () {
                          Navigator.pushNamed(context, Strings.dashboardScreen);
                        },
                      ),
                      MenuWidget(
                        title: translation(context).clients,
                        onTap: () {},
                      ),
                      MenuWidget(
                        title: translation(context).programs,
                        onTap: () {},
                      ),
                      MenuWidget(
                        title: translation(context).biompedancia,
                        onTap: () {},
                      ),
                      MenuWidget(
                        title: translation(context).tutorials,
                        onTap: () {},
                      ),
                      MenuWidget(
                        title: translation(context).settings,
                        onTap: () {
                          Navigator.pushNamed(context, Strings.settingScreen);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.05),
                    child: imageWidget(
                      image: Strings.logoIModel,
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
