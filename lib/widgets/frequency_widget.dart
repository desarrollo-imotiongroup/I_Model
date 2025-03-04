import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/textview.dart';

class FrequencyWidget extends StatelessWidget {
  final int frequency;
  final int pulse;
  final String duration;

  const FrequencyWidget(
      {required this.frequency,
      required this.pulse,
      required this.duration,
      super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return SizedBox(
      height: screenHeight * 0.04,
      child: Row(
        children: [
          TextView.title('${frequency.toString()} Hz',
              fontSize: duration != '00:00' ? 10.sp : 12.sp,
              color: AppColors.blackColor.withValues(alpha: 0.8)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: VerticalDivider(
              color: Colors.black,
              // Color of the divider
              thickness: 1,
              // Thickness of the divider
              width: 1,
              // Width of the space the divider occupies
              indent: 2,
              // Space above the divider
              endIndent: 0, // Space below the divider
            ),
          ),
          TextView.title('${pulse.toString()} ms',
              fontSize: duration != '00:00' ? 10.sp : 12.sp,
              color: AppColors.blackColor.withValues(alpha: 0.8)),
          duration != '00:00'
              ? Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                      child: VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                        width: 1,
                        indent: 2,
                        endIndent: 0, // Space below the divider
                      ),
                    ),
                    TextView.title(duration.toString(),
                        fontSize: 10.sp,
                        color: AppColors.blackColor.withValues(alpha: 0.8)),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
