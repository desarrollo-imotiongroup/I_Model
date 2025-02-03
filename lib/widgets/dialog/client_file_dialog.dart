import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/dummy.dart';
import 'package:i_model/view_models/client_controller.dart';
import 'package:i_model/widgets/check_box.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/graph/circle_painter.dart';
import 'package:i_model/widgets/graph/spider_graph.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/line_graph.dart';
import 'package:i_model/widgets/rounded_container.dart';
import 'package:i_model/widgets/table_text_info.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

void clientFileDialog(BuildContext context,) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final ClientController controller = Get.put(ClientController());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      List<Widget> subTabBarView = [
        Center(child: LineGraph(flSpotList: controller.fatFreeHydrationFlSpotList)),
        Center(child: LineGraph(flSpotList: controller.waterBalanceFlSpotList)),
        Center(child: LineGraph(flSpotList: controller.imcFlSpotList)),
        Center(child: LineGraph(flSpotList: controller.bodyFatFlSpotList)),
        Center(child: LineGraph(flSpotList: controller.muscleFlSpotList)),
        Center(child: LineGraph(flSpotList: controller.skeletonFlSpotList)),
      ];

      bool _isChecked = false;


      Text subTabBarText(String title, {required int index}){
        return TextView.title(
            title,
            lines: 2,
            fontSize: 10.sp,
            textAlign: TextAlign.center,
            isUnderLine: controller.selectedSubTabsIndex.value == index
                ? true
                : false,
            color: controller.selectedSubTabsIndex.value == index
                ? AppColors.pinkColor
                : AppColors.blackColor.withValues(alpha: 0.8)
        );
      }

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.9,
          decoration: BoxDecoration(
            color: AppColors.pureWhiteColor,
            borderRadius: BorderRadius.circular(screenHeight * 0.02),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3),
                spreadRadius: 3,
                blurRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenWidth * 0.015),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.005),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: TextView.title(
                              Strings.clientFile.toUpperCase(),
                              isUnderLine: true,
                              color: AppColors.pinkColor,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.dismissGraphs();
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close_sharp,
                            size: screenHeight * 0.04,
                            color: AppColors.blackColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: AppColors.pinkColor),

                  // Tab Bar Implementation
                  DefaultTabController(
                    length: 5, // Number of tabs
                    child: Column(
                      children: [
                        RoundedContainer(
                          width: double.infinity,
                          color: AppColors.greyColor,
                          borderColor: AppColors.transparentColor,
                          widget: TabBar(
                            labelColor: AppColors.pinkColor,
                            unselectedLabelColor:
                                AppColors.blackColor.withValues(alpha: 0.8),
                            indicatorColor: AppColors.pinkColor,
                            dividerColor: Colors.transparent,
                            labelStyle: GoogleFonts.oswald(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            tabs: [
                              Tab(text: Strings.personalData.toUpperCase()),
                              Tab(text: Strings.activities.toUpperCase()),
                              Tab(text: Strings.cards.toUpperCase()),
                              Tab(text: Strings.bioimpedancia.toUpperCase()),
                              Tab(text: Strings.groupActivities.toUpperCase()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.7,
                          child: TabBarView(
                            children: [
                              /// Personal Data content
                              Obx(
                                () => Column(
                                  children: [
                                    /// Name text field and status drop down
                                    Padding(
                                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: TextFieldLabel(
                                              label: Strings.name,
                                              textEditingController: controller.clientNameController,
                                            ),
                                          ),

                                          /// Client status drop down
                                          DropDownWidget(
                                              selectedValue: controller.selectedStatus.value,
                                              dropDownList: controller.clientStatusList,
                                              onChanged: (value){
                                                controller.selectedStatus.value = value;
                                              },
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.015,),
                                    ///  TextFields
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        /// TextFields 1st column
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            /// Gender text field
                                            SizedBox(height: screenHeight * 0.025,),

                                            DropDownLabelWidget(
                                                selectedValue: controller.clientSelectedGender.value,
                                                dropDownList: controller.genderList,
                                                onChanged: (value){
                                                  controller.clientSelectedGender.value = value;
                                                },
                                                label: Strings.gender
                                            ),
                                            SizedBox(height: screenHeight * 0.02,),

                                            /// Birth date text field
                                            TextFieldLabel(
                                                label: Strings.birthDate,
                                                textEditingController: controller.clientDobController,
                                            ),

                                            SizedBox(height: screenHeight * 0.01,),

                                            /// Phone text field
                                            TextFieldLabel(
                                              label: Strings.phone,
                                              textEditingController: controller.clientPhoneController,
                                              isAllowNumberOnly: true,
                                            )
                                          ],
                                        ),

                                        /// TextFields 2nd column
                                        Column(
                                          children: [
                                            /// Height text field
                                             TextFieldLabel(
                                              label: Strings.height,
                                              textEditingController: controller.clientHeightController,
                                               isAllowNumberOnly: true,
                                            ),

                                            SizedBox(height: screenHeight * 0.01,),

                                            /// Weight text field
                                            TextFieldLabel(
                                              label: Strings.weight,
                                              textEditingController: controller.clientWeightController,
                                              isAllowNumberOnly: true,
                                            ),

                                            SizedBox(height: screenHeight * 0.01,),

                                            /// Email text field
                                            TextFieldLabel(
                                              label: Strings.email,
                                              textEditingController: controller.clientEmailController,
                                              textInputAction: TextInputAction.done,
                                            )
                                          ],
                                        )
                                      ],
                                    ),

                                    SizedBox(height: screenHeight * 0.02,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        imageWidget(
                                            image: Strings.removeIcon,
                                            height: screenHeight * 0.08
                                        ),
                                        imageWidget(
                                            image: Strings.checkIcon,
                                            height: screenHeight * 0.08
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              /// Activities content
                              Obx(
                                    () => Column(
                                  children: [
                                    /// Name text field and status drop down
                                    Padding(
                                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: TextFieldLabel(
                                              label: Strings.name,
                                              textEditingController: controller.clientNameController,
                                              isReadOnly: true,
                                            ),
                                          ),

                                          /// Client status drop down
                                          DropDownWidget(
                                            selectedValue: controller.selectedStatus.value,
                                            dropDownList: controller.clientStatusList,
                                            isEnable: false,
                                            onChanged: (value){
                                              controller.selectedStatus.value = value;
                                            },
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.02,),

                                    /// Table data
                                      Expanded(
                                      child: SizedBox(
                                        width: screenWidth * 0.85,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              /// Table headers
                                              Row(
                                                children: [
                                                  tableTextInfo(
                                                      title: Strings.date,
                                                      fontSize: 10.sp,
                                                  ),
                                                  tableTextInfo(
                                                      title: Strings.hour,
                                                      fontSize: 10.sp,
                                                  ),
                                                  tableTextInfo(
                                                      title: Strings.cards,
                                                      fontSize: 10.sp,
                                                  ),
                                                  tableTextInfo(
                                                      title: Strings.points,
                                                      fontSize: 10.sp,
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          tableTextInfo(
                                                            title: Strings.eKcal,
                                                            fontSize: 10.sp,
                                                          ),
                                                          SizedBox(width: screenWidth * 0.035,)
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(height: screenHeight * 0.005,),
                                              CustomContainer(
                                                height: screenHeight * 0.37,
                                                width: double.infinity,
                                                color: AppColors.greyColor,
                                                widget: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: controller.clientActivity.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return  GestureDetector(
                                                      onTap: (){},
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
                                                            ),
                                                            child: RoundedContainer(
                                                                width: double.infinity,
                                                                borderColor: AppColors.transparentColor,
                                                                borderRadius: screenWidth * 0.006,
                                                                color: AppColors.pureWhiteColor,
                                                                widget: Row(
                                                                  children: [
                                                                    /// Table cells info
                                                                    tableTextInfo(
                                                                      title: controller.clientActivity[index].date,
                                                                      color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                    tableTextInfo(
                                                                      title: controller.clientActivity[index].hour,
                                                                      color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                    tableTextInfo(
                                                                      title: controller.clientActivity[index].card,
                                                                      color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                    tableTextInfo(
                                                                      title: controller.clientActivity[index].point,
                                                                      color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                    tableTextInfo(
                                                                      title: controller.clientActivity[index].ekal,
                                                                      color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                  ],
                                                                )
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        imageWidget(
                                            image: Strings.removeIcon,
                                            height: screenHeight * 0.08
                                        ),
                                        imageWidget(
                                            image: Strings.checkIcon,
                                            height: screenHeight * 0.08
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.03,)
                                  ],
                                ),
                              ),

                              /// Cards/bonos content
                              Obx(
                                    () => Column(
                                  children: [
                                    /// Name text field and status drop down
                                    Padding(
                                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: TextFieldLabel(
                                              label: Strings.name,
                                              textEditingController: controller.clientNameController,
                                              isReadOnly: true,
                                            ),
                                          ),

                                         Row(
                                           children: [
                                             /// Client status drop down
                                             DropDownWidget(
                                               selectedValue: controller.selectedStatus.value,
                                               dropDownList: controller.clientStatusList,
                                               isEnable: false,
                                               onChanged: (value){
                                                 controller.selectedStatus.value = value;
                                               },
                                             ),
                                             SizedBox(width: screenWidth * 0.01,),
                                             /// Add bonos button
                                             RoundedContainer(
                                                 borderRadius: screenHeight * 0.01,
                                                 width: screenWidth * 0.15,
                                                 padding: EdgeInsets.symmetric(
                                                     vertical: screenHeight * 0.013
                                                 ),
                                                 widget: TextView.title(
                                                     Strings.addPoints.toUpperCase(),
                                                     fontSize: 12.sp,
                                                     color: AppColors.blackColor.withValues(alpha: 0.8)
                                                 ))
                                           ],
                                         )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.02,),

                                    SizedBox(
                                      height: screenHeight * 0.42,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          /// Available points
                                          SizedBox(
                                            width: screenWidth * 0.32,
                                            child: Column(
                                              children: [
                                                TextView.title(
                                                  Strings.availablePoints.toUpperCase(),
                                                  color: AppColors.pinkColor,
                                                  fontSize: 11.sp,
                                                ),
                                                SizedBox(height: screenHeight * 0.02,),
                                                Expanded(
                                                  child: SizedBox(
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          /// Table headers
                                                          Row(
                                                            children: [
                                                              tableTextInfo(
                                                                title: Strings.date,
                                                                fontSize: 10.sp,
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    tableTextInfo(
                                                                      title: Strings.quantity,
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                    SizedBox(width: screenWidth * 0.02,),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: screenHeight * 0.005,),
                                                          CustomContainer(
                                                            height: screenHeight * 0.25,
                                                            width: double.infinity,
                                                            color: AppColors.greyColor,
                                                            widget: ListView.builder(
                                                              padding: EdgeInsets.zero,
                                                              itemCount: controller.availablePoints.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return  GestureDetector(
                                                                  onTap: (){},
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
                                                                        ),
                                                                        child: RoundedContainer(
                                                                            width: double.infinity,
                                                                            borderColor: AppColors.transparentColor,
                                                                            borderRadius: screenWidth * 0.006,
                                                                            color: AppColors.pureWhiteColor,
                                                                            widget: Row(
                                                                              children: [
                                                                                /// Table cells info
                                                                                tableTextInfo(
                                                                                  title: controller.availablePoints[index].date!,
                                                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                  fontSize: 10.sp,
                                                                                ),
                                                                                tableTextInfo(
                                                                                  title: controller.availablePoints[index].quantity.toString(),
                                                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                  fontSize: 10.sp,
                                                                                ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: screenHeight * 0.005,),
                                                /// Available points total
                                                CustomContainer(
                                                    height: screenHeight * 0.07,
                                                    width: double.infinity,
                                                    color: AppColors.greyColor,
                                                    widget: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        TextView.title(
                                                          Strings.total.toUpperCase(),
                                                          fontSize: 10.sp,
                                                          color: AppColors.blackColor.withValues(alpha: 0.8)
                                                        ),
                                                        TextView.title(
                                                            controller.availablePoints.length.toString(),
                                                            fontSize: 10.sp,
                                                            color: AppColors.pinkColor
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.018,),

                                          /// Consumed points
                                          SizedBox(
                                            width: screenWidth * 0.35,
                                            child: Column(
                                              children: [
                                                TextView.title(
                                                  Strings.consumedPoints.toUpperCase(),
                                                  color: AppColors.pinkColor,
                                                  fontSize: 11.sp,
                                                ),
                                                SizedBox(height: screenHeight * 0.02,),
                                                /// Table
                                                Expanded(
                                                  child: SizedBox(
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          /// Table headers
                                                          Row(
                                                            children: [
                                                              tableTextInfo(
                                                                title: Strings.date,
                                                                fontSize: 10.sp,
                                                              ),
                                                              tableTextInfo(
                                                                title: Strings.hour,
                                                                fontSize: 10.sp,
                                                              ),
                                                              tableTextInfo(
                                                                title: Strings.quantity,
                                                                fontSize: 10.sp,
                                                              ),
                                                              SizedBox(width: screenWidth * 0.02,),
                                                            ],
                                                          ),
                                                          SizedBox(height: screenHeight * 0.005,),
                                                          CustomContainer(
                                                            height: screenHeight * 0.25,
                                                            width: double.infinity,
                                                            color: AppColors.greyColor,
                                                            widget: ListView.builder(
                                                              padding: EdgeInsets.zero,
                                                              itemCount: controller.consumedPoints.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return  GestureDetector(
                                                                  onTap: (){},
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
                                                                        ),
                                                                        child: RoundedContainer(
                                                                            width: double.infinity,
                                                                            borderColor: AppColors.transparentColor,
                                                                            borderRadius: screenWidth * 0.006,
                                                                            color: AppColors.pureWhiteColor,
                                                                            widget: Row(
                                                                              children: [
                                                                                /// Table cells info
                                                                                tableTextInfo(
                                                                                  title: controller.consumedPoints[index].date!,
                                                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                  fontSize: 10.sp,
                                                                                ),
                                                                                tableTextInfo(
                                                                                  title: controller.consumedPoints[index].hour.toString(),
                                                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                  fontSize: 10.sp,
                                                                                ),
                                                                                tableTextInfo(
                                                                                  title: controller.consumedPoints[index].quantity.toString(),
                                                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                  fontSize: 10.sp,
                                                                                ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: screenHeight * 0.005,),
                                                /// Consumed points total
                                                CustomContainer(
                                                    height: screenHeight * 0.07,
                                                    width: double.infinity,
                                                    color: AppColors.greyColor,
                                                    widget: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        TextView.title(
                                                            Strings.total.toUpperCase(),
                                                            fontSize: 10.sp,
                                                            color: AppColors.blackColor.withValues(alpha: 0.8)
                                                        ),
                                                        TextView.title(
                                                            controller.consumedPoints.length.toString(),
                                                            fontSize: 10.sp,
                                                            color: AppColors.redColor
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        imageWidget(
                                            image: Strings.removeIcon,
                                            height: screenHeight * 0.08
                                        ),
                                        imageWidget(
                                            image: Strings.checkIcon,
                                            height: screenHeight * 0.08
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.03,)
                                  ],
                                ),
                              ),

                              /// Bioimpedancia content
                              Obx(() =>
                              controller.showLineGraph.value
                                  /// Line graph
                                  ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Vertical TabBar on the left
                                  RoundedContainer(
                                    color: AppColors.greyColor,
                                    borderColor: AppColors.transparentColor,
                                    width: screenWidth * 0.15, // Adjust the width of the vertical tab bar
                                    widget: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ListTile(
                                          title: subTabBarText(
                                              Strings.fatFreeHydration.toUpperCase(),
                                              index: 0
                                          ),
                                          onTap: () => controller.onSubTabSelected(0),
                                          selected:  controller.selectedSubTabsIndex.value == 0,
                                        ),
                                        ListTile(
                                          title: subTabBarText(
                                              Strings.waterBalance.toUpperCase(),
                                              index: 1
                                          ),
                                          onTap: () => controller.onSubTabSelected(1),
                                          selected: controller.selectedSubTabsIndex.value == 1,
                                        ),
                                        ListTile(
                                          title: subTabBarText(
                                              Strings.imc.toUpperCase(),
                                              index: 2
                                          ),
                                          onTap: () => controller.onSubTabSelected(2),
                                          selected: controller.selectedSubTabsIndex.value == 2,
                                        ),
                                        ListTile(
                                          title: subTabBarText(
                                              Strings.bodyFat.toUpperCase(),
                                              index: 3
                                          ),
                                          onTap: () => controller.onSubTabSelected(3),
                                          selected: controller.selectedSubTabsIndex.value == 3,
                                        ),
                                        ListTile(
                                          title: subTabBarText(
                                              Strings.muscle.toUpperCase(),
                                              index: 4
                                          ),
                                          onTap: () => controller.onSubTabSelected(4),
                                          selected: controller.selectedSubTabsIndex.value == 4,
                                        ),
                                        ListTile(
                                          title: subTabBarText(
                                              Strings.skeleton.toUpperCase(),
                                              index: 5
                                          ),
                                          onTap: () => controller.onSubTabSelected(5),
                                          selected: controller.selectedSubTabsIndex.value == 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Expanded(
                                    child: IndexedStack(
                                      index: controller.selectedSubTabsIndex.value,
                                      children: subTabBarView,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight *0.04,
                                        left: screenWidth * 0.02
                                    ),
                                    child: GestureDetector(
                                      onTap: (){
                                        controller.showLineGraph.value = false;
                                      },
                                      child: Image(
                                        image: AssetImage(
                                          Strings.backIcon,
                                        ),
                                        height: screenHeight * 0.07,
                                      ),
                                    ),
                                  ),
                                ],)

                                  /// Spider graph
                                  : controller.showSpiderGraph.value
                                  ? Padding(
                                  padding: EdgeInsets.only(right: screenWidth * 0.04),
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// Table data
                                      SizedBox(
                                        width: screenWidth * 0.37,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: screenHeight * 0.04
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  TextView.title(
                                                    '${Strings.date.toUpperCase()}: ${controller.selectedDate.value}',
                                                    color: AppColors.pinkColor,
                                                    fontSize: 12.sp,
                                                  ),
                                                  TextView.title(
                                                    '${Strings.hour.toUpperCase()}: ${controller.selectedHour.value}',
                                                    color: AppColors.pinkColor,
                                                    fontSize: 12.sp,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: screenWidth * 0.02,),
                                              Expanded(
                                                child: SizedBox(
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        /// Table headers
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            tableTextInfo(
                                                              title: Strings.nothing,
                                                              fontSize: 10.sp,
                                                            ),
                                                            tableTextInfo(
                                                              title: Strings.calculatedValue,
                                                              fontSize: 10.sp,
                                                              lines: 2,
                                                              isCenter: true
                                                            ),
                                                            tableTextInfo(
                                                              title: Strings.reference,
                                                              fontSize: 10.sp,
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  tableTextInfo(
                                                                    title: Strings.result,
                                                                    fontSize: 10.sp,
                                                                  ),
                                                                  SizedBox(width: screenWidth * 0.02,)
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: screenHeight * 0.005,),
                                                        CustomContainer(
                                                          height: screenHeight * 0.48,
                                                          width: double.infinity,
                                                          color: AppColors.greyColor,
                                                          widget: ListView.builder(
                                                            padding: EdgeInsets.zero,
                                                            itemCount: controller.bioimpedanciaGraphData.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              return  GestureDetector(
                                                                onTap: (){},
                                                                child: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
                                                                      ),
                                                                      child: RoundedContainer(
                                                                          width: double.infinity,
                                                                          borderColor: AppColors.transparentColor,
                                                                          borderRadius: screenWidth * 0.006,
                                                                          color: AppColors.pureWhiteColor,
                                                                          widget: Row(
                                                                            children: [
                                                                              /// Table cells info
                                                                              tableTextInfo(
                                                                                title: controller.bioimpedanciaGraphData[index].name,
                                                                                color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                fontSize: 10.sp,
                                                                                lines: 2,
                                                                                isCenter: true
                                                                              ),
                                                                              tableTextInfo(
                                                                                title: controller.bioimpedanciaGraphData[index].calculatedValue,
                                                                                color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                fontSize: 10.sp,
                                                                              ),
                                                                              tableTextInfo(
                                                                                title: controller.bioimpedanciaGraphData[index].reference,
                                                                                color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                fontSize: 10.sp,
                                                                              ),
                                                                              tableTextInfo(
                                                                                title: controller.bioimpedanciaGraphData[index].result,
                                                                                color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                fontSize: 10.sp,
                                                                              ),
                                                                            ],
                                                                          )
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      /// Graph
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: screenHeight * 0.04,
                                                bottom: screenHeight * 0.04
                                            ),
                                            child: GestureDetector(
                                              onTap: (){
                                                controller.showSpiderGraph.value = false;
                                              },
                                              child: Image(
                                                image: AssetImage(
                                                  Strings.backIcon,
                                                ),
                                                height: screenHeight * 0.07,
                                              ),
                                            ),
                                          ),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CirclePainterWidget(),
                                              SpiderChart(data: [90, 75, 90, 60, 85, 85]),
                                            ],),
                                        ],
                                      ),
                                    ],
                                  ),
                                )

                                  /// Tables and evolution button
                                  : Column(
                                  children: [
                                    /// Name text field and status drop down
                                    Padding(
                                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: TextFieldLabel(
                                              label: Strings.name,
                                              textEditingController: controller.clientNameController,
                                              isReadOnly: true,
                                            ),
                                          ),

                                          /// Client status drop down
                                          DropDownWidget(
                                            selectedValue: controller.selectedStatus.value,
                                            dropDownList: controller.clientStatusList,
                                            isEnable: false,
                                            onChanged: (value){
                                              controller.selectedStatus.value = value;
                                            },
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.02,),


                                    Row(
                                      children: [
                                        /// Table data
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                /// Table headers
                                                Row(
                                                  children: [
                                                    tableTextInfo(
                                                      title: Strings.date,
                                                      fontSize: 10.sp,
                                                    ),
                                                    tableTextInfo(
                                                      title: Strings.hour,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: screenHeight * 0.005,),
                                                CustomContainer(
                                                  height: screenHeight * 0.37,
                                                  width: double.infinity,
                                                  color: AppColors.greyColor,
                                                  widget: ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    itemCount: controller.bioimpedanciaData.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return  GestureDetector(
                                                        onTap: (){
                                                          controller.showSpiderGraph.value = true;
                                                          controller.selectedDate.value = controller.bioimpedanciaData[index].date!;
                                                          controller.selectedHour.value = controller.bioimpedanciaData[index].hour!;
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
                                                              ),
                                                              child: RoundedContainer(
                                                                  width: double.infinity,
                                                                  borderColor: AppColors.transparentColor,
                                                                  borderRadius: screenWidth * 0.006,
                                                                  color: AppColors.pureWhiteColor,
                                                                  widget: Row(
                                                                    children: [
                                                                      /// Table cells info
                                                                      tableTextInfo(
                                                                        title: controller.bioimpedanciaData[index].date!,
                                                                        color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                        fontSize: 10.sp,
                                                                      ),
                                                                      tableTextInfo(
                                                                        title: controller.bioimpedanciaData[index].hour!,
                                                                        color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                        fontSize: 10.sp,
                                                                      ),
                                                                    ],
                                                                  )
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.1,),
                                        RoundedContainer(
                                            onTap: (){
                                              controller.showLineGraph.value = true;
                                            },
                                            borderRadius: screenHeight * 0.01,
                                            width: screenWidth * 0.15,
                                            padding: EdgeInsets.symmetric(
                                                vertical: screenHeight * 0.013
                                            ),
                                            widget: TextView.title(
                                                Strings.evolution.toUpperCase(),
                                                fontSize: 12.sp,
                                                color: AppColors.blackColor.withValues(alpha: 0.8)
                                            )),
                                        SizedBox(width: screenWidth * 0.05,),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.01,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        imageWidget(
                                            image: Strings.removeIcon,
                                            height: screenHeight * 0.08
                                        ),
                                        imageWidget(
                                            image: Strings.checkIcon,
                                            height: screenHeight * 0.08
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.03,)
                                  ],
                                ),
                              ),

                              /// Content for Grupos Activos
                              Obx(
                                    () => Column(
                                  children: [
                                    /// Name text field and status drop down
                                    Padding(
                                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: TextFieldLabel(
                                              label: Strings.name,
                                              textEditingController: controller.clientNameController,
                                              isReadOnly: true,
                                            ),
                                          ),

                                          /// Client status drop down
                                          DropDownWidget(
                                            selectedValue: controller.selectedStatus.value,
                                            dropDownList: controller.clientStatusList,
                                            isEnable: false,
                                            onChanged: (value){
                                              controller.selectedStatus.value = value;
                                            },
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.02,),

                                    Expanded(
                                      child: SizedBox(
                                        width: screenWidth * 0.85,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    /// Upper back
                                                    CheckBox(
                                                    title: Strings.upperBack,
                                                    isChecked: controller.isUpperBackChecked.value,
                                                      onTap: (){
                                                      controller.toggleUpperBack();
                                                    },),

                                                    /// Middle back
                                                    CheckBox(
                                                      title: Strings.middleBack,
                                                      isChecked: controller.isMiddleBackChecked.value,
                                                      onTap: (){
                                                        controller.toggleMiddleBack();
                                                      },),

                                                    /// Lumbares / lower back
                                                    CheckBox(
                                                      title: Strings.lowerBack,
                                                      isChecked: controller.isLowerBackChecked.value,
                                                      onTap: (){
                                                        controller.toggleLowerBack();
                                                      },),

                                                    /// Glutes
                                                    CheckBox(
                                                      title: Strings.glutes,
                                                      isChecked: controller.isGlutesChecked.value,
                                                      onTap: (){
                                                        controller.toggleGlutes();
                                                      },),

                                                    /// hamstrings / Isquios
                                                    CheckBox(
                                                      title: Strings.hamstrings,
                                                      isChecked: controller.isHamstringsChecked.value,
                                                      onTap: (){
                                                        controller.toggleHamstrings();
                                                      },),
                                                  ],
                                                ),
                                                SizedBox(width: screenWidth * 0.05,),
                                                Stack(
                                                  children: [
                                                    imageWidget(
                                                        image: Strings.avatarBackViewIcon
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    imageWidget(
                                                        image: Strings.avatarFrontViewIcon
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: screenWidth * 0.05,),
                                                Column(
                                                  children: [
                                                    /// Chest / pecho
                                                    CheckBox(
                                                    title: Strings.chest,
                                                    isChecked: controller.isChestChecked.value,
                                                      onTap: (){
                                                      controller.toggleChest();
                                                    },),

                                                    /// Abdominal
                                                    CheckBox(
                                                      title: Strings.abdominals,
                                                      isChecked: controller.isAbdominalChecked.value,
                                                      onTap: (){
                                                        controller.toggleAbdominal();
                                                      },),

                                                    /// Legs / piernas
                                                    CheckBox(
                                                      title: Strings.legs,
                                                      isChecked: controller.isLegsChecked.value,
                                                      onTap: (){
                                                        controller.toggleLegs();
                                                      },),

                                                    /// Arms / Brazos
                                                    CheckBox(
                                                      title: Strings.arms,
                                                      isChecked: controller.isArmsChecked.value,
                                                      onTap: (){
                                                        controller.toggleArms();
                                                      },),

                                                    /// Extra
                                                    CheckBox(
                                                      title: Strings.extra,
                                                      isChecked: controller.isExtraChecked.value,
                                                      onTap: (){
                                                        controller.toggleExtra();
                                                      },),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.01,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        imageWidget(
                                            image: Strings.removeIcon,
                                            height: screenHeight * 0.08
                                        ),
                                        imageWidget(
                                            image: Strings.checkIcon,
                                            height: screenHeight * 0.08
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.03,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
