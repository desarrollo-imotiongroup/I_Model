import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/textview.dart';

class DropDownWidget extends StatelessWidget {
  final String selectedValue;
  final List<dynamic> dropDownList;
  final Function(String value) onChanged;
  final double? width;
  final bool? isEnable;

  const DropDownWidget(
      {required this.selectedValue,
      required this.dropDownList,
      required this.onChanged,
      this.width,
      this.isEnable,
      super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return RoundedContainer(
      width: width ?? screenWidth * 0.25,
      color: AppColors.greyColor,
      borderColor: AppColors.transparentColor,
      widget: DropdownButton<String>(
        padding: EdgeInsets.zero,
        isDense: true,
        underline: SizedBox.shrink(),
        dropdownColor: AppColors.greyColor,
        value: selectedValue.isEmpty ? null : selectedValue,
        // If empty, set to null
        hint: selectedValue.isEmpty
            ? TextView.title(Strings.pleaseSelect.toUpperCase(),
                fontSize: 11.sp,
                color:
                    AppColors.blackColor.withValues(alpha: 0.8)) // Placeholder
            : null,
        isExpanded: true,
        iconEnabledColor: AppColors.pinkColor,
        iconSize: screenHeight * 0.04,
        items: dropDownList.map((dynamic value) {
          return DropdownMenuItem<String>(
            value: value,
            child: TextView.title(value.toUpperCase(),
                fontSize: 11.sp,
                color: AppColors.blackColor.withValues(alpha: 0.8)),
          );
        }).toList(),
        onChanged: isEnable ?? true
            ? (String? value) {
                onChanged(value!);
              }
            : null,
      ),
    );
  }
}

class DropDownLabelWidget extends StatelessWidget {
  final String selectedValue;
  final List<dynamic> dropDownList;
  final Function(String value) onChanged;
  final double? width;
  final String label;
  final bool? isEnable;

  const DropDownLabelWidget(
      {required this.selectedValue,
      required this.dropDownList,
      required this.onChanged,
      this.width,
      required this.label,
      this.isEnable = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView.title(label.toUpperCase(),
            fontSize: 11.sp,
            color: AppColors.blackColor.withValues(alpha: 0.8)),
        RoundedContainer(
          width: width ?? screenWidth * 0.25,
          color: AppColors.greyColor,
          borderColor: AppColors.transparentColor,
          widget: DropdownButton<String>(
            padding: EdgeInsets.zero,
            isDense: true,
            underline: SizedBox.shrink(),
            dropdownColor: AppColors.greyColor,
            value: selectedValue.isEmpty ? null : selectedValue,
            // If empty, set to null
            hint: selectedValue.isEmpty
                ? TextView.title(Strings.pleaseSelect.toUpperCase(),
                    fontSize: 11.sp,
                    color: AppColors.blackColor
                        .withValues(alpha: 0.8)) // Placeholder
                : null,
            isExpanded: true,
            iconEnabledColor: AppColors.pinkColor,
            iconSize: screenHeight * 0.04,
            items: dropDownList.map((dynamic value) {
              return DropdownMenuItem<String>(
                value: value,
                child: TextView.title(value.toUpperCase(),
                    fontSize: 11.sp,
                    color: AppColors.blackColor.withValues(alpha: 0.8)),
              );
            }).toList(),
            onChanged: isEnable ?? true
                ? (String? value) {
                    onChanged(value!);
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
