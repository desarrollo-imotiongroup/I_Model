import 'dart:async';
import 'package:get/get.dart';

class DataController extends GetxController {
  RxList<int> chestPercentage = <int>[].obs;
  RxInt selectedIndex = 0.obs;
  List<Timer?> timers = [];

  void initializePrograms(int count) {
    chestPercentage.value = List.generate(count, (index) => 0);
    timers = List.generate(count, (index) => null);
  }

  void selectContainer(int index) {
    selectedIndex.value = index;
  }

  void updateProgramValue() {
    chestPercentage[selectedIndex.value]++;
  }

  void startTimer(int index) {
    timers[index]?.cancel(); // Cancel existing timer if running
    timers[index] = Timer.periodic(Duration(seconds: 1), (timer) {
      chestPercentage[index]++;
    });
  }

  void stopTimer(int index) {
    timers[index]?.cancel();
    timers[index] = null;
  }

  @override
  void onClose() {
    for (var timer in timers) {
      timer?.cancel();
    }
    super.onClose();
  }
}

