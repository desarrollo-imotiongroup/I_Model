import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textview.dart';

class EKalWidget extends StatelessWidget {
  final String mciName;
  // final String mciId;

  const EKalWidget({
    required this.mciName,
    // required this.mciId,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Column(
      children: [
        TextView.title(
            mciName,
            fontSize: 10.sp,
            color: AppColors.blackColor.withValues(alpha: 0.8)
        ),
        SizedBox(height: screenHeight * 0.006,),
        imageWidget(
            image: Strings.ekCalIcon,
            height: screenHeight * 0.025
        ),
        SizedBox(height: screenHeight * 0.006,),
        // TextView.title(
        //     mciId,
        //     fontSize: 10.sp,
        //     color: AppColors.blackColor.withValues(alpha: 0.8)
        // ),
      ],
    );
  }
}


// Column(
//   children: [
//     EKalWidget(
//       mciName: Strings.mciNames[0],
//       mciId: Strings.mciIDs[0],
//     ),
//     SizedBox(height: screenHeight * 0.04),
//     EKalWidget(
//       mciName: Strings.mciNames[1],
//       mciId: Strings.mciIDs[1],
//     ),
//   ],
// ),
// SizedBox(width: screenWidth * 0.02),
// Column(
//   children: [
//     EKalWidget(
//       mciName: Strings.mciNames[0],
//       mciId: Strings.mciIDs[0],
//     ),
//     SizedBox(height: screenHeight * 0.04),
//     EKalWidget(
//       mciName: Strings.mciNames[1],
//       mciId: Strings.mciIDs[1],
//     ),
//   ],
// ),
// SizedBox(width: screenWidth * 0.01),