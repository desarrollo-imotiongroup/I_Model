// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:i_model/view_models/dashboard_controller.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: OverlayExample(),
//   ));
// }
//
// class OverlayExample extends StatelessWidget {
//   final DashboardController controller = Get.put(DashboardController()); // Initialize the controller
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Overlay with GetX Example'),
//       ),
//       body: Center(
//         // Wrap the button with Obx to dynamically observe the counter
//         child: Obx(() => ElevatedButton(
//           onPressed: () => _showOverlay(context),
//           child: Text('Show Overlay - Counter: ${controller.counter.value}'),
//         )),
//       ),
//     );
//   }
//
//   void _showOverlay(BuildContext context) {
//     final overlayState = Overlay.of(context);
//     late OverlayEntry overlayEntry;
//
//     overlayEntry = OverlayEntry(
//       builder: (context) => Material(
//         color: Colors.black54, // Semi-transparent background
//         child: Center(
//           child: Container(
//             height: 800,
//             width: 600,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Display counter value using Obx here
//                 Obx(() => Text(
//                   'Counter: ${controller.counter.value}', // Dynamically updated
//                   style: const TextStyle(fontSize: 20),
//                 )),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: controller.incrementCounter, // Increment the counter
//                   child: const Text('Increment Counter'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (overlayEntry.mounted) {
//                       overlayEntry.remove(); // Safely remove the overlay
//                     }
//                   },
//                   child: const Text('Close Overlay'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//
//     overlayState.insert(overlayEntry);
//   }
// }
