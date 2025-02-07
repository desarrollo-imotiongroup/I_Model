import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/widgets/containers/unbounded_container.dart';
import 'package:i_model/widgets/top_title_button.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

void resetPasswordOverlay(BuildContext context) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  final ValueNotifier<bool> isNewPasswordObscured = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isRepeatPasswordObscured = ValueNotifier<bool>(true);

  overlayEntry = OverlayEntry(
    builder: (context) {
      MediaQueryData mediaQuery = MediaQuery.of(context);
      double screenWidth = mediaQuery.size.width;
      double screenHeight = mediaQuery.size.height;

      return Material(
        color: Colors.black54, // Semi-transparent background
        child: Center(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                width: screenWidth * 0.5,
                height: screenHeight * 0.5,
                decoration: boxDecoration(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenWidth * 0.015),
                      TopTitleButton(
                        title: Strings.resetPassword,
                        onCancel: () {
                          if (overlayEntry.mounted) {
                            overlayEntry.remove();
                          }
                        },
                      ),
                      Divider(color: AppColors.pinkColor),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Column(
                          children: [
                            // New Password Field with Toggle
                            ValueListenableBuilder<bool>(
                              valueListenable: isNewPasswordObscured,
                              builder: (context, isObscuredValue, _) {
                                return TextFieldLabel(
                                  width: double.infinity,
                                  label: Strings.newPassword,
                                  textEditingController: newPasswordController,
                                  fontSize: 12.sp,
                                  isObscureText: isObscuredValue,
                                  isSuffixIcon: true,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isObscuredValue ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      isNewPasswordObscured.value = !isNewPasswordObscured.value;
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            // Repeat Password Field with Toggle
                            ValueListenableBuilder<bool>(
                              valueListenable: isRepeatPasswordObscured,
                              builder: (context, isObscuredValue, _) {
                                return TextFieldLabel(
                                  width: double.infinity,
                                  label: Strings.repeatPassword,
                                  textEditingController: repeatPasswordController,
                                  fontSize: 12.sp,
                                  isObscureText: isObscuredValue,
                                  isSuffixIcon: true,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isObscuredValue ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      isRepeatPasswordObscured.value = !isRepeatPasswordObscured.value;
                                    },
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: screenWidth * 0.025),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                              child: UnboundedContainer(
                                borderColor: AppColors.pinkColor,
                                onTap: () {},
                                widget: TextView.title(
                                  Strings.logIn.toUpperCase(),
                                  fontSize: 11.sp,
                                  color: AppColors.pinkColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  overlayState.insert(overlayEntry);
}
