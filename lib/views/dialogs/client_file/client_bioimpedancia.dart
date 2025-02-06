import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/client_controller.dart';
import 'package:i_model/views/graph/circle_painter.dart';
import 'package:i_model/views/graph/spider_graph.dart';
import 'package:i_model/widgets/containers/custom_container.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/line_graph.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/table_text_info.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

class ClientBioimpedancia extends StatelessWidget {
  const ClientBioimpedancia({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;
    double screenWidth = mediaQuery.size.width;
    final ClientController controller = Get.put(ClientController());

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

    List<Widget> subTabBarView = [
      Center(child: LineGraph(flSpotList: controller.fatFreeHydrationFlSpotList)),
      Center(child: LineGraph(flSpotList: controller.waterBalanceFlSpotList)),
      Center(child: LineGraph(flSpotList: controller.imcFlSpotList)),
      Center(child: LineGraph(flSpotList: controller.bodyFatFlSpotList)),
      Center(child: LineGraph(flSpotList: controller.muscleFlSpotList)),
      Center(child: LineGraph(flSpotList: controller.skeletonFlSpotList)),
    ];



    return Obx(() =>
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
                  fontSize: 11.sp,
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
    ));
  }
}
