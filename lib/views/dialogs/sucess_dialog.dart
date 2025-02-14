import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/textview.dart';

void showSuccessDialog(BuildContext context, {String? title}) {
  showDialog(
    context: context,
    barrierDismissible: false,  // Prevents dialog from closing when tapped outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),  // Rounded corners
        ),
        backgroundColor: Colors.green[100],  // Soft green background for success
        title: Center(
          child: Icon(
            Icons.check_circle,  // Success icon
            color: Colors.green,
            size: 60,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Strings.success.toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 10),
            TextView.title(
              title?.toUpperCase() ?? Strings.successMsg.toUpperCase(),
              fontSize: 10.sp,
              color: Colors.green[700],
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Close the dialog
            },
            child: TextView.title(
              fontSize: 12.sp,
              translation(context).gotIt.toUpperCase(),
              color: Colors.green[800],
            ),
          ),
        ],
      );
    },
  );
}
