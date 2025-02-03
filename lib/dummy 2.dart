// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:i_model/core/colors.dart';
// import 'package:i_model/core/strings.dart';
// import 'package:i_model/dummy.dart';
// import 'package:i_model/view_models/client_controller.dart';
// import 'package:i_model/widgets/drop_down_widget.dart';
// import 'package:i_model/widgets/graph/circle_painter.dart';
// import 'package:i_model/widgets/graph/spider_graph.dart';
// import 'package:i_model/widgets/image_widget.dart';
// import 'package:i_model/widgets/rounded_container.dart';
// import 'package:i_model/widgets/table_text_info.dart';
// import 'package:i_model/widgets/textfield_label.dart';
// import 'package:i_model/widgets/textview.dart';
//
// void clientFileDialog(BuildContext context,) {
//   MediaQueryData mediaQuery = MediaQuery.of(context);
//   double screenWidth = mediaQuery.size.width;
//   double screenHeight = mediaQuery.size.height;
//   final ClientController controller = Get.put(ClientController());
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//
//       Widget _buildTab(String text, int index) {
//         // late TabController _tabController;
//         // bool isSelected = _tabController.index == index;
//
//         return GestureDetector(
//           onTap: () {
//             // setState(() {
//             //   _tabController.index = index;
//             // });
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(left: 20.0),
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.1,
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               decoration: BoxDecoration(
//                 // color: isSelected ? const Color(0xFF494949) : Colors.transparent,
//                 color: const Color(0xFF494949) ,
//                 borderRadius:
//                 const BorderRadius.horizontal(left: Radius.circular(7.0)),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   color:const Color(0xFF2be4f3),
//                   // color: isSelected ? const Color(0xFF2be4f3) : Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   decoration:
//                   TextDecoration.underline,
//                   // isSelected ? TextDecoration.underline : TextDecoration.none,
//                   decorationColor: const Color(0xFF2be4f3),
//                 ),
//               ),
//             ),
//           ),
//         );
//       }
//
//
//       Widget _buildTabBar() {
//         return Padding(
//             padding: const EdgeInsets.only(
//               left: 20.0,
//               bottom: 10.0,
//             ),
//             child: Container(
//               color: Colors.black, // Fondo negro para la barra
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 // Distribuir uniformemente las pestañas
//                 children: [
//                   _buildTab('Hidratación sin grasa'.toUpperCase(), 0),
//                   _buildTab('Equilibrio hídrico'.toUpperCase(), 1),
//                   _buildTab('IMC', 2),
//                   _buildTab('Masa grasa'.toUpperCase(), 3),
//                   _buildTab('Músculo'.toUpperCase(), 4),
//                   _buildTab('Esqueleto'.toUpperCase(), 5),
//                 ],
//               ),
//             ));
//       }
//
//       Widget _buildTabContent(String content, List<FlSpot> spots) {
//         double screenWidth = MediaQuery.of(context).size.width;
//         double screenHeight = MediaQuery.of(context).size.height;
//
//         return Container(
//           padding: const EdgeInsets.all(20.0),
//           child: SizedBox(
//             height: screenHeight,
//             width: screenWidth,
//             child: LineChart(
//               LineChartData(
//                 gridData: const FlGridData(show: true),
//                 titlesData: FlTitlesData(
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 38,
//                       getTitlesWidget: (value, meta) {
//                         switch (value.toInt()) {
//                           case 0:
//                             return const Text('Ene');
//                           case 1:
//                             return const Text('Feb');
//                           case 2:
//                             return const Text('Mar');
//                           case 3:
//                             return const Text('Abr');
//                           case 4:
//                             return const Text('May');
//                           case 5:
//                             return const Text('Jun');
//                         }
//                         return const Text('');
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 40,
//                       getTitlesWidget: (value, meta) {
//                         switch (value.toInt()) {
//                           case 0:
//                             return Text('Excelente',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12.sp,
//                                 ));
//                           case 20:
//                             return Text('Muy bien',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12.sp,
//                                 ));
//                           case 40:
//                             return Text('Normal',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12.sp,
//                                 ));
//                           case 60:
//                             return Text('Cerca de la norma',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12.sp,
//                                 ));
//                           case 80:
//                             return Text('A vigilar',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12.sp,
//                                 ));
//                           case 100:
//                             return Text('A tratar',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12.sp,
//                                 ));
//                         }
//                         return const Text('');
//                       },
//                     ),
//                   ),
//                   topTitles:
//                   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles:
//                   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 borderData: FlBorderData(
//                   show: true,
//                   border: Border.all(color: Colors.white, width: 1),
//                 ),
//                 minX: 0,
//                 maxX: 5,
//                 minY: 0,
//                 maxY: 100,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: spots,
//                     isCurved: true,
//                     color: const Color(0xFF2be4f3),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color(0xFF2be4f3),
//                           Colors.transparent,
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                     aboveBarData: BarAreaData(show: false),
//                   ),
//                   LineChartBarData(
//                     spots: [
//                       FlSpot(0, 50),
//                       FlSpot(5, 50), // Dibuja una línea horizontal a 50
//                     ],
//                     isCurved: false,
//                     color: Colors.white,
//                     dotData: FlDotData(show: false),
//                     belowBarData: BarAreaData(show: false),
//                     aboveBarData: BarAreaData(show: false),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }
//
//
//       List<FlSpot> _generateSampleDataHidratacion() {
//         return [
//           FlSpot(0, 10),
//           FlSpot(1, 30),
//           FlSpot(2, 60),
//           FlSpot(3, 90),
//           FlSpot(4, 40),
//           FlSpot(5, 80),
//         ];
//       }
//
//       List<FlSpot> _generateSampleDataEquilibrio() {
//         return [
//           FlSpot(0, 20),
//           FlSpot(1, 40),
//           FlSpot(2, 80),
//           FlSpot(3, 60),
//           FlSpot(4, 30),
//           FlSpot(5, 70),
//         ];
//       }
//
//       List<FlSpot> _generateSampleDataIMC() {
//         return [
//           FlSpot(0, 30),
//           FlSpot(1, 50),
//           FlSpot(2, 90),
//           FlSpot(3, 30),
//           FlSpot(4, 20),
//           FlSpot(5, 40),
//         ];
//       }
//
//       List<FlSpot> _generateSampleDataMasaGrasa() {
//         return [
//           FlSpot(0, 40),
//           FlSpot(1, 60),
//           FlSpot(2, 20),
//           FlSpot(3, 80),
//           FlSpot(4, 50),
//           FlSpot(5, 10),
//         ];
//       }
//
//       List<FlSpot> _generateSampleDataMusculo() {
//         return [
//           FlSpot(0, 50),
//           FlSpot(1, 20),
//           FlSpot(2, 40),
//           FlSpot(3, 70),
//           FlSpot(4, 90),
//           FlSpot(5, 60),
//         ];
//       }
//
//       List<FlSpot> _generateSampleDataSaludOsea() {
//         return [
//           FlSpot(0, 60),
//           FlSpot(1, 30),
//           FlSpot(2, 70),
//           FlSpot(3, 20),
//           FlSpot(4, 10),
//           FlSpot(5, 50),
//         ];
//       }
//
//
//       Widget _buildTabBarView() {
//         return IndexedStack(
//           // index: _tabController.index,
//           children: [
//             _buildTabContent('Contenido de HIDRATACIÓN SIN GRASA',
//                 _generateSampleDataHidratacion()),
//             _buildTabContent(
//                 'Contenido de EQUILIBRIO HÍDRICO', _generateSampleDataEquilibrio()),
//             _buildTabContent('Contenido de IMC', _generateSampleDataIMC()),
//             _buildTabContent(
//                 'Contenido de MASA GRASA', _generateSampleDataMasaGrasa()),
//             _buildTabContent('Contenido de MÚSCULO', _generateSampleDataMusculo()),
//             _buildTabContent(
//                 'Contenido de SALUD ÓSEA', _generateSampleDataSaludOsea()),
//           ],
//         );
//       }
//
//
//
//
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Container(
//           width: screenWidth * 0.8,
//           height: screenHeight * 0.9,
//           decoration: BoxDecoration(
//             color: AppColors.pureWhiteColor,
//             borderRadius: BorderRadius.circular(screenHeight * 0.02),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withValues(alpha: 0.3),
//                 spreadRadius: 3,
//                 blurRadius: 2,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: screenWidth * 0.015),
//                   Padding(
//                     padding:
//                     EdgeInsets.symmetric(horizontal: screenWidth * 0.005),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Center(
//                             child: TextView.title(
//                               Strings.clientFile.toUpperCase(),
//                               isUnderLine: true,
//                               color: AppColors.pinkColor,
//                               fontSize: 15.sp,
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Icon(
//                             Icons.close_sharp,
//                             size: screenHeight * 0.04,
//                             color: AppColors.blackColor.withValues(alpha: 0.8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(color: AppColors.pinkColor),
//
//                   // Tab Bar Implementation
//                   DefaultTabController(
//                     length: 5, // Number of tabs
//                     child: Column(
//                       children: [
//                         RoundedContainer(
//                           width: double.infinity,
//                           color: AppColors.greyColor,
//                           borderColor: AppColors.transparentColor,
//                           widget: TabBar(
//                             labelColor: AppColors.pinkColor,
//                             unselectedLabelColor:
//                             AppColors.blackColor.withValues(alpha: 0.8),
//                             indicatorColor: AppColors.pinkColor,
//                             dividerColor: Colors.transparent,
//                             labelStyle: GoogleFonts.oswald(
//                               fontSize: 11.sp,
//                               fontWeight: FontWeight.w400,
//                             ),
//                             tabs: [
//                               Tab(text: Strings.personalData.toUpperCase()),
//                               Tab(text: Strings.activities.toUpperCase()),
//                               Tab(text: Strings.cards.toUpperCase()),
//                               Tab(text: Strings.bioimpedancia.toUpperCase()),
//                               Tab(text: Strings.groupActivities.toUpperCase()),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: screenHeight * 0.7,
//                           child: TabBarView(
//                             children: [
//                               /// Personal Data content
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     Flexible(
//                                       flex: 2, // Esto asigna un 20% del ancho disponible al TabBar
//                                       child: _buildTabBar(),
//                                     ),
//                                     SizedBox(
//                                       width: MediaQuery.of(context).size.width * 0.03,
//                                     ),
//                                     Flexible(
//                                       flex: 8, // El contenido ocupa el 80% del ancho
//                                       child: _buildTabBarView(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // Obx(
//                               //   () => Column(
//                               //     children: [
//                               //       /// Name text field and status drop down
//                               //       Padding(
//                               //         padding: EdgeInsets.only(top: screenHeight * 0.01),
//                               //         child: Row(
//                               //           crossAxisAlignment: CrossAxisAlignment.end,
//                               //           children: [
//                               //             Expanded(
//                               //               child: TextFieldLabel(
//                               //                 label: Strings.name,
//                               //                 textEditingController: controller.clientNameController,
//                               //               ),
//                               //             ),
//                               //
//                               //             /// Client status drop down
//                               //             DropDownWidget(
//                               //                 selectedValue: controller.selectedStatus.value,
//                               //                 dropDownList: controller.clientStatusList,
//                               //                 onChanged: (value){
//                               //                   controller.selectedStatus.value = value;
//                               //                 },
//                               //             )
//                               //           ],
//                               //         ),
//                               //       ),
//                               //
//                               //       SizedBox(height: screenHeight * 0.015,),
//                               //       ///  TextFields
//                               //       Row(
//                               //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               //         crossAxisAlignment: CrossAxisAlignment.center,
//                               //         children: [
//                               //           /// TextFields 1st column
//                               //           Column(
//                               //             crossAxisAlignment: CrossAxisAlignment.start,
//                               //             children: [
//                               //               /// Gender text field
//                               //               SizedBox(height: screenHeight * 0.025,),
//                               //
//                               //               DropDownLabelWidget(
//                               //                   selectedValue: controller.clientSelectedGender.value,
//                               //                   dropDownList: controller.genderList,
//                               //                   onChanged: (value){
//                               //                     controller.clientSelectedGender.value = value;
//                               //                   },
//                               //                   label: Strings.gender
//                               //               ),
//                               //               SizedBox(height: screenHeight * 0.02,),
//                               //
//                               //               /// Birth date text field
//                               //               TextFieldLabel(
//                               //                   label: Strings.birthDate,
//                               //                   textEditingController: controller.clientDobController,
//                               //               ),
//                               //
//                               //               SizedBox(height: screenHeight * 0.01,),
//                               //
//                               //               /// Phone text field
//                               //               TextFieldLabel(
//                               //                 label: Strings.phone,
//                               //                 textEditingController: controller.clientPhoneController,
//                               //                 isAllowNumberOnly: true,
//                               //               )
//                               //             ],
//                               //           ),
//                               //
//                               //           /// TextFields 2nd column
//                               //           Column(
//                               //             children: [
//                               //               /// Height text field
//                               //                TextFieldLabel(
//                               //                 label: Strings.height,
//                               //                 textEditingController: controller.clientHeightController,
//                               //                  isAllowNumberOnly: true,
//                               //               ),
//                               //
//                               //               SizedBox(height: screenHeight * 0.01,),
//                               //
//                               //               /// Weight text field
//                               //               TextFieldLabel(
//                               //                 label: Strings.weight,
//                               //                 textEditingController: controller.clientWeightController,
//                               //                 isAllowNumberOnly: true,
//                               //               ),
//                               //
//                               //               SizedBox(height: screenHeight * 0.01,),
//                               //
//                               //               /// Email text field
//                               //               TextFieldLabel(
//                               //                 label: Strings.email,
//                               //                 textEditingController: controller.clientEmailController,
//                               //                 textInputAction: TextInputAction.done,
//                               //               )
//                               //             ],
//                               //           )
//                               //         ],
//                               //       ),
//                               //
//                               //       SizedBox(height: screenHeight * 0.02,),
//                               //
//                               //       Row(
//                               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               //         children: [
//                               //           imageWidget(
//                               //               image: Strings.removeIcon,
//                               //               height: screenHeight * 0.08
//                               //           ),
//                               //           imageWidget(
//                               //               image: Strings.checkIcon,
//                               //               height: screenHeight * 0.08
//                               //           ),
//                               //         ],
//                               //       )
//                               //     ],
//                               //   ),
//                               // ),
//
//                               /// Activities content
//                               Obx(
//                                     () => Column(
//                                   children: [
//                                     /// Name text field and status drop down
//                                     Padding(
//                                       padding: EdgeInsets.only(top: screenHeight * 0.01),
//                                       child: Row(
//                                         crossAxisAlignment: CrossAxisAlignment.end,
//                                         children: [
//                                           Expanded(
//                                             child: TextFieldLabel(
//                                               label: Strings.name,
//                                               textEditingController: controller.clientNameController,
//                                               isReadOnly: true,
//                                             ),
//                                           ),
//
//                                           /// Client status drop down
//                                           DropDownWidget(
//                                             selectedValue: controller.selectedStatus.value,
//                                             dropDownList: controller.clientStatusList,
//                                             isEnable: false,
//                                             onChanged: (value){
//                                               controller.selectedStatus.value = value;
//                                             },
//                                           )
//                                         ],
//                                       ),
//                                     ),
//
//                                     SizedBox(height: screenHeight * 0.02,),
//
//                                     /// Table data
//                                     Expanded(
//                                       child: SizedBox(
//                                         width: screenWidth * 0.85,
//                                         child: SingleChildScrollView(
//                                           child: Column(
//                                             children: [
//                                               /// Table headers
//                                               Row(
//                                                 children: [
//                                                   tableTextInfo(
//                                                     title: Strings.date,
//                                                     fontSize: 10.sp,
//                                                   ),
//                                                   tableTextInfo(
//                                                     title: Strings.hour,
//                                                     fontSize: 10.sp,
//                                                   ),
//                                                   tableTextInfo(
//                                                     title: Strings.cards,
//                                                     fontSize: 10.sp,
//                                                   ),
//                                                   tableTextInfo(
//                                                     title: Strings.points,
//                                                     fontSize: 10.sp,
//                                                   ),
//                                                   Expanded(
//                                                     child: Row(
//                                                       children: [
//                                                         tableTextInfo(
//                                                           title: Strings.eKcal,
//                                                           fontSize: 10.sp,
//                                                         ),
//                                                         SizedBox(width: screenWidth * 0.035,)
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(height: screenHeight * 0.005,),
//                                               CustomContainer(
//                                                 height: screenHeight * 0.37,
//                                                 width: double.infinity,
//                                                 color: AppColors.greyColor,
//                                                 widget: ListView.builder(
//                                                   padding: EdgeInsets.zero,
//                                                   itemCount: controller.clientActivity.length,
//                                                   itemBuilder: (BuildContext context, int index) {
//                                                     return  GestureDetector(
//                                                       onTap: (){},
//                                                       child: Column(
//                                                         children: [
//                                                           Padding(
//                                                             padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
//                                                             ),
//                                                             child: RoundedContainer(
//                                                                 width: double.infinity,
//                                                                 borderColor: AppColors.transparentColor,
//                                                                 borderRadius: screenWidth * 0.006,
//                                                                 color: AppColors.pureWhiteColor,
//                                                                 widget: Row(
//                                                                   children: [
//                                                                     /// Table cells info
//                                                                     tableTextInfo(
//                                                                       title: controller.clientActivity[index].date,
//                                                                       color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                       fontSize: 10.sp,
//                                                                     ),
//                                                                     tableTextInfo(
//                                                                       title: controller.clientActivity[index].hour,
//                                                                       color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                       fontSize: 10.sp,
//                                                                     ),
//                                                                     tableTextInfo(
//                                                                       title: controller.clientActivity[index].card,
//                                                                       color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                       fontSize: 10.sp,
//                                                                     ),
//                                                                     tableTextInfo(
//                                                                       title: controller.clientActivity[index].point,
//                                                                       color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                       fontSize: 10.sp,
//                                                                     ),
//                                                                     tableTextInfo(
//                                                                       title: controller.clientActivity[index].ekal,
//                                                                       color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                       fontSize: 10.sp,
//                                                                     ),
//                                                                   ],
//                                                                 )
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: screenHeight * 0.01,),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         imageWidget(
//                                             image: Strings.removeIcon,
//                                             height: screenHeight * 0.08
//                                         ),
//                                         imageWidget(
//                                             image: Strings.checkIcon,
//                                             height: screenHeight * 0.08
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: screenHeight * 0.03,)
//                                   ],
//                                 ),
//                               ),
//
//                               /// Cards/bonos content
//                               Obx(
//                                     () => Column(
//                                   children: [
//                                     /// Name text field and status drop down
//                                     Padding(
//                                       padding: EdgeInsets.only(top: screenHeight * 0.01),
//                                       child: Row(
//                                         crossAxisAlignment: CrossAxisAlignment.end,
//                                         children: [
//                                           Expanded(
//                                             child: TextFieldLabel(
//                                               label: Strings.name,
//                                               textEditingController: controller.clientNameController,
//                                               isReadOnly: true,
//                                             ),
//                                           ),
//
//                                           Row(
//                                             children: [
//                                               /// Client status drop down
//                                               DropDownWidget(
//                                                 selectedValue: controller.selectedStatus.value,
//                                                 dropDownList: controller.clientStatusList,
//                                                 isEnable: false,
//                                                 onChanged: (value){
//                                                   controller.selectedStatus.value = value;
//                                                 },
//                                               ),
//                                               SizedBox(width: screenWidth * 0.01,),
//                                               /// Add bonos button
//                                               RoundedContainer(
//                                                   borderRadius: screenHeight * 0.01,
//                                                   width: screenWidth * 0.15,
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: screenHeight * 0.013
//                                                   ),
//                                                   widget: TextView.title(
//                                                       Strings.addPoints.toUpperCase(),
//                                                       fontSize: 12.sp,
//                                                       color: AppColors.blackColor.withValues(alpha: 0.8)
//                                                   ))
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//
//                                     SizedBox(height: screenHeight * 0.02,),
//
//                                     SizedBox(
//                                       height: screenHeight * 0.42,
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           /// Available points
//                                           SizedBox(
//                                             width: screenWidth * 0.32,
//                                             child: Column(
//                                               children: [
//                                                 TextView.title(
//                                                   Strings.availablePoints.toUpperCase(),
//                                                   color: AppColors.pinkColor,
//                                                   fontSize: 11.sp,
//                                                 ),
//                                                 SizedBox(height: screenHeight * 0.02,),
//                                                 Expanded(
//                                                   child: SizedBox(
//                                                     child: SingleChildScrollView(
//                                                       child: Column(
//                                                         children: [
//                                                           /// Table headers
//                                                           Row(
//                                                             children: [
//                                                               tableTextInfo(
//                                                                 title: Strings.date,
//                                                                 fontSize: 10.sp,
//                                                               ),
//                                                               Expanded(
//                                                                 child: Row(
//                                                                   children: [
//                                                                     tableTextInfo(
//                                                                       title: Strings.quantity,
//                                                                       fontSize: 10.sp,
//                                                                     ),
//                                                                     SizedBox(width: screenWidth * 0.02,),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(height: screenHeight * 0.005,),
//                                                           CustomContainer(
//                                                             height: screenHeight * 0.25,
//                                                             width: double.infinity,
//                                                             color: AppColors.greyColor,
//                                                             widget: ListView.builder(
//                                                               padding: EdgeInsets.zero,
//                                                               itemCount: controller.availablePoints.length,
//                                                               itemBuilder: (BuildContext context, int index) {
//                                                                 return  GestureDetector(
//                                                                   onTap: (){},
//                                                                   child: Column(
//                                                                     children: [
//                                                                       Padding(
//                                                                         padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
//                                                                         ),
//                                                                         child: RoundedContainer(
//                                                                             width: double.infinity,
//                                                                             borderColor: AppColors.transparentColor,
//                                                                             borderRadius: screenWidth * 0.006,
//                                                                             color: AppColors.pureWhiteColor,
//                                                                             widget: Row(
//                                                                               children: [
//                                                                                 /// Table cells info
//                                                                                 tableTextInfo(
//                                                                                   title: controller.availablePoints[index].date!,
//                                                                                   color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                                   fontSize: 10.sp,
//                                                                                 ),
//                                                                                 tableTextInfo(
//                                                                                   title: controller.availablePoints[index].quantity.toString(),
//                                                                                   color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                                   fontSize: 10.sp,
//                                                                                 ),
//                                                                               ],
//                                                                             )
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 );
//                                                               },
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: screenHeight * 0.005,),
//                                                 /// Available points total
//                                                 CustomContainer(
//                                                     height: screenHeight * 0.07,
//                                                     width: double.infinity,
//                                                     color: AppColors.greyColor,
//                                                     widget: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                       children: [
//                                                         TextView.title(
//                                                             Strings.total.toUpperCase(),
//                                                             fontSize: 10.sp,
//                                                             color: AppColors.blackColor.withValues(alpha: 0.8)
//                                                         ),
//                                                         TextView.title(
//                                                             controller.availablePoints.length.toString(),
//                                                             fontSize: 10.sp,
//                                                             color: AppColors.pinkColor
//                                                         ),
//                                                       ],
//                                                     ))
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(width: screenWidth * 0.018,),
//
//                                           /// Consumed points
//                                           SizedBox(
//                                             width: screenWidth * 0.35,
//                                             child: Column(
//                                               children: [
//                                                 TextView.title(
//                                                   Strings.consumedPoints.toUpperCase(),
//                                                   color: AppColors.pinkColor,
//                                                   fontSize: 11.sp,
//                                                 ),
//                                                 SizedBox(height: screenHeight * 0.02,),
//                                                 /// Table
//                                                 Expanded(
//                                                   child: SizedBox(
//                                                     child: SingleChildScrollView(
//                                                       child: Column(
//                                                         children: [
//                                                           /// Table headers
//                                                           Row(
//                                                             children: [
//                                                               tableTextInfo(
//                                                                 title: Strings.date,
//                                                                 fontSize: 10.sp,
//                                                               ),
//                                                               tableTextInfo(
//                                                                 title: Strings.hour,
//                                                                 fontSize: 10.sp,
//                                                               ),
//                                                               tableTextInfo(
//                                                                 title: Strings.quantity,
//                                                                 fontSize: 10.sp,
//                                                               ),
//                                                               SizedBox(width: screenWidth * 0.02,),
//                                                             ],
//                                                           ),
//                                                           SizedBox(height: screenHeight * 0.005,),
//                                                           CustomContainer(
//                                                             height: screenHeight * 0.25,
//                                                             width: double.infinity,
//                                                             color: AppColors.greyColor,
//                                                             widget: ListView.builder(
//                                                               padding: EdgeInsets.zero,
//                                                               itemCount: controller.consumedPoints.length,
//                                                               itemBuilder: (BuildContext context, int index) {
//                                                                 return  GestureDetector(
//                                                                   onTap: (){},
//                                                                   child: Column(
//                                                                     children: [
//                                                                       Padding(
//                                                                         padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
//                                                                         ),
//                                                                         child: RoundedContainer(
//                                                                             width: double.infinity,
//                                                                             borderColor: AppColors.transparentColor,
//                                                                             borderRadius: screenWidth * 0.006,
//                                                                             color: AppColors.pureWhiteColor,
//                                                                             widget: Row(
//                                                                               children: [
//                                                                                 /// Table cells info
//                                                                                 tableTextInfo(
//                                                                                   title: controller.consumedPoints[index].date!,
//                                                                                   color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                                   fontSize: 10.sp,
//                                                                                 ),
//                                                                                 tableTextInfo(
//                                                                                   title: controller.consumedPoints[index].hour.toString(),
//                                                                                   color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                                   fontSize: 10.sp,
//                                                                                 ),
//                                                                                 tableTextInfo(
//                                                                                   title: controller.consumedPoints[index].quantity.toString(),
//                                                                                   color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                                   fontSize: 10.sp,
//                                                                                 ),
//                                                                               ],
//                                                                             )
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 );
//                                                               },
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: screenHeight * 0.005,),
//                                                 /// Consumed points total
//                                                 CustomContainer(
//                                                     height: screenHeight * 0.07,
//                                                     width: double.infinity,
//                                                     color: AppColors.greyColor,
//                                                     widget: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                       children: [
//                                                         TextView.title(
//                                                             Strings.total.toUpperCase(),
//                                                             fontSize: 10.sp,
//                                                             color: AppColors.blackColor.withValues(alpha: 0.8)
//                                                         ),
//                                                         TextView.title(
//                                                             controller.consumedPoints.length.toString(),
//                                                             fontSize: 10.sp,
//                                                             color: AppColors.redColor
//                                                         ),
//                                                       ],
//                                                     ))
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: screenHeight * 0.01,),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         imageWidget(
//                                             image: Strings.removeIcon,
//                                             height: screenHeight * 0.08
//                                         ),
//                                         imageWidget(
//                                             image: Strings.checkIcon,
//                                             height: screenHeight * 0.08
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: screenHeight * 0.03,)
//                                   ],
//                                 ),
//                               ),
//
//                               /// Bioimpedancia content
//                               Obx(() =>
//                               controller.isEvolutionClicked.value
//                                   ? Padding(
//                                 padding: EdgeInsets.only(right: screenWidth * 0.04),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     /// Table data
//                                     SizedBox(
//                                       width: screenWidth * 0.37,
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             top: screenHeight * 0.04
//                                         ),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                               children: [
//                                                 TextView.title(
//                                                   '${Strings.date.toUpperCase()}: 01-31-2025',
//                                                   color: AppColors.pinkColor,
//                                                   fontSize: 12.sp,
//                                                 ),
//                                                 TextView.title(
//                                                   '${Strings.hour.toUpperCase()}: 12:21',
//                                                   color: AppColors.pinkColor,
//                                                   fontSize: 12.sp,
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(height: screenWidth * 0.02,),
//                                             Expanded(
//                                               child: SizedBox(
//                                                 child: SingleChildScrollView(
//                                                   child: Column(
//                                                     children: [
//                                                       /// Table headers
//                                                       Row(
//                                                         crossAxisAlignment: CrossAxisAlignment.end,
//                                                         children: [
//                                                           tableTextInfo(
//                                                             title: Strings.nothing,
//                                                             fontSize: 10.sp,
//                                                           ),
//                                                           tableTextInfo(
//                                                               title: Strings.calculatedValue,
//                                                               fontSize: 10.sp,
//                                                               lines: 2,
//                                                               isCenter: true
//                                                           ),
//                                                           tableTextInfo(
//                                                             title: Strings.reference,
//                                                             fontSize: 10.sp,
//                                                           ),
//                                                           Expanded(
//                                                             child: Row(
//                                                               children: [
//                                                                 tableTextInfo(
//                                                                   title: Strings.result,
//                                                                   fontSize: 10.sp,
//                                                                 ),
//                                                                 SizedBox(width: screenWidth * 0.02,)
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       SizedBox(height: screenHeight * 0.005,),
//                                                       CustomContainer(
//                                                         height: screenHeight * 0.48,
//                                                         width: double.infinity,
//                                                         color: AppColors.greyColor,
//                                                         widget: ListView.builder(
//                                                           padding: EdgeInsets.zero,
//                                                           itemCount: controller.bioimpedanciaGraphData.length,
//                                                           itemBuilder: (BuildContext context, int index) {
//                                                             return  GestureDetector(
//                                                               onTap: (){},
//                                                               child: Column(
//                                                                 children: [
//                                                                   Padding(
//                                                                     padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
//                                                                     ),
//                                                                     child: RoundedContainer(
//                                                                         width: double.infinity,
//                                                                         borderColor: AppColors.transparentColor,
//                                                                         borderRadius: screenWidth * 0.006,
//                                                                         color: AppColors.pureWhiteColor,
//                                                                         widget: Row(
//                                                                           children: [
//                                                                             /// Table cells info
//                                                                             tableTextInfo(
//                                                                                 title: controller.bioimpedanciaGraphData[index].name,
//                                                                                 color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                                 fontSize: 10.sp,
//                                                                                 lines: 2,
//                                                                                 isCenter: true
//                                                                             ),
//                                                                             tableTextInfo(
//                                                                               title: controller.bioimpedanciaGraphData[index].calculatedValue,
//                                                                               color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                               fontSize: 10.sp,
//                                                                             ),
//                                                                             tableTextInfo(
//                                                                               title: controller.bioimpedanciaGraphData[index].reference,
//                                                                               color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                               fontSize: 10.sp,
//                                                                             ),
//                                                                             tableTextInfo(
//                                                                               title: controller.bioimpedanciaGraphData[index].result,
//                                                                               color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                               fontSize: 10.sp,
//                                                                             ),
//                                                                           ],
//                                                                         )
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             );
//                                                           },
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//
//                                     /// Graph
//                                     Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         CirclePainterWidget(),
//                                         SpiderChart(data: [90, 75, 90, 60, 85, 85]),
//                                       ],),
//                                   ],
//                                 ),
//                               )
//                                   : Column(
//                                 children: [
//                                   /// Name text field and status drop down
//                                   Padding(
//                                     padding: EdgeInsets.only(top: screenHeight * 0.01),
//                                     child: Row(
//                                       crossAxisAlignment: CrossAxisAlignment.end,
//                                       children: [
//                                         Expanded(
//                                           child: TextFieldLabel(
//                                             label: Strings.name,
//                                             textEditingController: controller.clientNameController,
//                                             isReadOnly: true,
//                                           ),
//                                         ),
//
//                                         /// Client status drop down
//                                         DropDownWidget(
//                                           selectedValue: controller.selectedStatus.value,
//                                           dropDownList: controller.clientStatusList,
//                                           isEnable: false,
//                                           onChanged: (value){
//                                             controller.selectedStatus.value = value;
//                                           },
//                                         )
//                                       ],
//                                     ),
//                                   ),
//
//                                   SizedBox(height: screenHeight * 0.02,),
//
//
//                                   Row(
//                                     children: [
//                                       /// Table data
//                                       Expanded(
//                                         child: SingleChildScrollView(
//                                           child: Column(
//                                             children: [
//                                               /// Table headers
//                                               Row(
//                                                 children: [
//                                                   tableTextInfo(
//                                                     title: Strings.date,
//                                                     fontSize: 10.sp,
//                                                   ),
//                                                   tableTextInfo(
//                                                     title: Strings.hour,
//                                                     fontSize: 10.sp,
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(height: screenHeight * 0.005,),
//                                               CustomContainer(
//                                                 height: screenHeight * 0.37,
//                                                 width: double.infinity,
//                                                 color: AppColors.greyColor,
//                                                 widget: ListView.builder(
//                                                   padding: EdgeInsets.zero,
//                                                   itemCount: controller.clientActivity.length,
//                                                   itemBuilder: (BuildContext context, int index) {
//                                                     return  GestureDetector(
//                                                       onTap: (){},
//                                                       child: Column(
//                                                         children: [
//                                                           Padding(
//                                                             padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
//                                                             ),
//                                                             child: RoundedContainer(
//                                                                 width: double.infinity,
//                                                                 borderColor: AppColors.transparentColor,
//                                                                 borderRadius: screenWidth * 0.006,
//                                                                 color: AppColors.pureWhiteColor,
//                                                                 widget: Row(
//                                                                   children: [
//                                                                     /// Table cells info
//                                                                     tableTextInfo(
//                                                                       title: controller.clientActivity[index].date,
//                                                                       color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                       fontSize: 10.sp,
//                                                                     ),
//                                                                     tableTextInfo(
//                                                                       title: controller.clientActivity[index].hour,
//                                                                       color: AppColors.blackColor.withValues(alpha: 0.8),
//                                                                       fontSize: 10.sp,
//                                                                     ),
//                                                                   ],
//                                                                 )
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: screenWidth * 0.1,),
//                                       RoundedContainer(
//                                           borderRadius: screenHeight * 0.01,
//                                           width: screenWidth * 0.15,
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: screenHeight * 0.013
//                                           ),
//                                           widget: TextView.title(
//                                               Strings.evolution.toUpperCase(),
//                                               fontSize: 12.sp,
//                                               color: AppColors.blackColor.withValues(alpha: 0.8)
//                                           )),
//                                       SizedBox(width: screenWidth * 0.05,),
//                                     ],
//                                   ),
//                                   SizedBox(height: screenHeight * 0.01,),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       imageWidget(
//                                           image: Strings.removeIcon,
//                                           height: screenHeight * 0.08
//                                       ),
//                                       imageWidget(
//                                           image: Strings.checkIcon,
//                                           height: screenHeight * 0.08
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: screenHeight * 0.03,)
//                                 ],
//                               ),
//                               ),
//
//                               /// Content for Grupos Activos
//                               Container(
//                                 child: Center(
//                                   child: Text('Grupos Activos Content'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
