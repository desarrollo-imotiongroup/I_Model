import 'package:flutter/material.dart';
import 'package:i_model/core/colors.dart';
import 'package:intl/intl.dart';

class HelperMethods{
  static Future<String?> selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    DateTime lastDate = DateTime.now();

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1910),
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: AppColors.pinkColor, // Color of the selected date and header
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary, // Color of buttons (cancel, ok)
            ),
            dialogBackgroundColor: Colors.white, // Background color of the dialogs
          ),
          child: child!,
        );
      },
    ) ?? selectedDate;

    if (picked != selectedDate) {
      selectedDate = picked;
      // Format the date to "dd/MM/yyyy"
      String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      return formattedDate; // Return the formatted date
    }

    return null;
  }
}