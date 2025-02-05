import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textfield_label.dart';

class TextFieldImage extends StatelessWidget {
  final String icon;
  final String label;
  final TextEditingController textEditingController;
  final TextInputAction? textInputAction;
  final String? unit;

  const TextFieldImage({
      required this.icon,
      required this.label,
      required this.textEditingController,
      this.textInputAction,
      this.unit,
      super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        imageWidget(
            image: icon,
            height: screenHeight * 0.08
        ),
        SizedBox(width: screenWidth * 0.005,),
        TextFieldLabel(
          width: screenWidth * 0.15,
          label: label,
          unit: unit,
          textEditingController: textEditingController,
          textInputAction: textInputAction ?? TextInputAction.next,
          fontSize: 11.sp,
          isAllowNumberOnly: true,
        ),
      ],
    );
  }
}
