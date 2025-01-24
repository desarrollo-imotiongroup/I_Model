import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/textview.dart';

class SelectLanguage extends StatelessWidget {
  final Function()? onCancel;

  const SelectLanguage({
    this.onCancel,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    final List<String> languages = [
      'ESPAÑOL',
      'ENGLISH',
      'FRANÇAIS',
      'ITALIANO',
      'PORTUGUÊS',
      'DEUTSCH',
    ];

    String selectedLanguage = 'ESPAÑOL';

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
            spreadRadius: 3,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: screenWidth * 0.01,),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.01),
                      child: TextView.title(
                        Strings.languageSelection,
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
                    )
                ),
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
          SizedBox(height: screenHeight * 0.02,),

          Container(
            height: screenHeight * 0.3,
            width: screenWidth * 0.3,
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: screenWidth * 0.2,
                    decoration: BoxDecoration(
                      color: AppColors.pureWhiteColor,
                      borderRadius: BorderRadius.circular(screenHeight * 0.02),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.3), // Shadow color
                          spreadRadius: 3, // How wide the shadow spreads
                          blurRadius: 1, // The blur effect
                          offset: Offset(0, 3), // Changes position of shadow (x, y)
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        languages[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                      leading: Radio<String>(
                        value: languages[index],
                        groupValue: selectedLanguage,
                        activeColor: Colors.pink,
                        onChanged: (value) {

                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )

        ],
      ),
    );
  }
}
