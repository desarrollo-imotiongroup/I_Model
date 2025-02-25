import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/widgets/eckal_widget.dart';

class EkcalPageView extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  EkcalPageView({Key? key}) : super(key: key);

  // Helper method to build a grid page with two columns.
  Widget buildGridPage(List<Widget> pageItems, double screenWidth, double screenHeight) {
    // Left column gets the extra item if the count is odd.
    final int leftCount = (pageItems.length + 1) ~/ 2;
    final List<Widget> leftItems = pageItems.sublist(0, leftCount);
    final List<Widget> rightItems = pageItems.sublist(leftCount);

    List<Widget> buildColumnItems(List<Widget> columnItems) {
      return columnItems
          .asMap()
          .entries
          .map((entry) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          entry.value,
          if (entry.key != columnItems.length - 1)
            SizedBox(height: screenHeight * 0.04),
        ],
      ))
          .toList();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: buildColumnItems(leftItems),
        ),
        SizedBox(width: screenWidth * 0.02),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: buildColumnItems(rightItems),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth  = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      // Build items dynamically from the controller observable list.
      final List<Widget> items = List.generate(
        controller.selectedClientNames.length,
            (index) => EKalWidget(
          mciName: controller.selectedClientNames[index].toUpperCase(),
          // If you have an ID list or any other info, include it here.
          // mciId: controller.selectedClientIDs[index],
        ),
      );

      final int totalItems = items.length;
      List<Widget> pages = [];

      if (totalItems <= 4) {
        pages.add(buildGridPage(items, screenWidth, screenHeight));
      } else {
        pages.add(buildGridPage(items.sublist(0, 4), screenWidth, screenHeight));
        pages.add(buildGridPage(items.sublist(4), screenWidth, screenHeight));
      }

      return SizedBox(
        width: screenWidth * 0.19,
        height: screenHeight * 0.25, // adjust as needed
        child: PageView(
          children: pages,
        ),
      );
    });
  }
}
