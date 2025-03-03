import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/dummy/controller.dart';

class HomeScreen extends StatelessWidget {
  final DataController dataController = Get.put(DataController());
  final int containerCount = 5;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    dataController.initializePrograms(containerCount);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("IndexedStack with Timers")),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Container Selection Row
              Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(containerCount, (index) {
                    return GestureDetector(
                      onTap: () => dataController.selectContainer(index),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: dataController.selectedIndex.value == index
                              ? Colors.blue.withOpacity(0.6)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Data ${index + 1}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                ),
              )),
              SizedBox(height: 20),

              // IndexedStack for Container Content
              Expanded(
                child: Obx(() => IndexedStack(
                  index: dataController.selectedIndex.value,
                  children: List.generate(containerCount, (index) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Value: ${dataController.chestPercentage[index]}",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => dataController.updateProgramValue(),
                            child: Text("Increment Value"),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => dataController.startTimer(index),
                                child: Text("Start Timer"),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => dataController.stopTimer(index),
                                child: Text("Stop Timer"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

