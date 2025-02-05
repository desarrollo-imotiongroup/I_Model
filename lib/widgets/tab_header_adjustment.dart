import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/widgets/table_text_info.dart';

Widget tabHeaderAdjustment(
  BuildContext context, {
  required String title,
  double? padding,
  bool isEnd = false
}) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;

  return Expanded(
    child: Row(
      children: [
         SizedBox(
          width: isEnd ? 0 : padding ?? screenWidth * 0.04,
        ),
        tableTextInfo(
          title: title,
          fontSize: 10.sp,
        ),
        SizedBox(
          width: isEnd ? padding ?? screenWidth * 0.04 : 0,
        ),
      ],
    ),
  );
}
