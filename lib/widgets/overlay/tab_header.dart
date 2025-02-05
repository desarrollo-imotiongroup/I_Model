import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/rounded_container.dart';

class TabHeader extends StatelessWidget {
  final List<Widget> tabs;
  final double? width;
  final Color? bgColor;
  final Color? unSelectedColor;

  const TabHeader({
    required this.tabs,
    this.width,
    this.bgColor,
    this.unSelectedColor,
    super.key});

  @override
  Widget build(BuildContext context) {
    return  RoundedContainer(
      width: width ?? double.infinity,
      color: bgColor ?? AppColors.greyColor,
      borderColor: AppColors.transparentColor,
      widget: TabBar(
        labelColor: AppColors.pinkColor,
        unselectedLabelColor: unSelectedColor
            ?? AppColors.blackColor.withValues(alpha: 0.8),
        indicatorColor: AppColors.pinkColor,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.oswald(
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
        ),
        tabs: tabs,
      ),
    );
  }
}
