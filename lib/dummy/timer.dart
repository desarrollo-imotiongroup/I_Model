// Future<void> startContractionTimeCycle() async {
//   isContractionPauseCycleActive[selectedDeviceIndex.value] = true;
//   contractionProgress[selectedDeviceIndex.value] = 1.0;
//   double decrementAmount = 1.0 / (contractionSeconds[selectedDeviceIndex.value] * 10);
//   int totalDurationInSeconds = contractionSeconds[selectedDeviceIndex.value];
//
//   print('In contraction cycle: ${isElectroOn[selectedDeviceIndex.value]}');
//
//   // Start electrostimulation if needed.
//   if (!isElectroOn[selectedDeviceIndex.value]) {
//     startFullElectrostimulationTrajeProcess(
//         selectedMacAddress[selectedDeviceIndex.value], selectedProgramName[selectedDeviceIndex.value])
//         .then((success) {
//       isElectroOn[selectedDeviceIndex.value] = true;
//     });
//   }
//
//   // Immediately set UI to max value.
//   remainingContractionSeconds[selectedDeviceIndex.value] = totalDurationInSeconds.toDouble();
//
//   // Introduce firstTick flag to skip first decrement.
//   bool firstTick = true;
//
//   /// Calculate the seconds while decreasing progress value to show on line painters
//   contractionCycleTimer[selectedDeviceIndex.value] = Timer.periodic(Duration(milliseconds: 100), (timer) {
//     if (firstTick) {
//       firstTick = false;
//       // Ensure the UI remains at the max value for the first tick.
//       remainingContractionSeconds[selectedDeviceIndex.value] = totalDurationInSeconds.toDouble();
//       return;
//     }
//     if (contractionProgress[selectedDeviceIndex.value] > 0) {
//       // Update UI
//       remainingContractionSeconds[selectedDeviceIndex.value] = (totalDurationInSeconds * contractionProgress[selectedDeviceIndex.value]).ceilToDouble();
//       contractionProgress[selectedDeviceIndex.value] -= decrementAmount;
//     }
//     else {
//       contractionProgress[selectedDeviceIndex.value] = 0;
//       remainingContractionSeconds[selectedDeviceIndex.value] = 0;
//       contractionCycleTimer[selectedDeviceIndex.value]?.cancel();
//       startPauseTimeCycle();
//     }
//   });
// }

// Future<void> startPauseTimeCycle() async {
//   pauseProgress[selectedDeviceIndex.value] = 1.0;
//   double decrementAmount = 1.0 / (pauseSeconds[selectedDeviceIndex.value] * 10);
//   int totalDurationInSeconds = pauseSeconds[selectedDeviceIndex.value];
//
//   // Immediately set UI to max value.
//   remainingPauseSeconds[selectedDeviceIndex.value] = totalDurationInSeconds.toDouble();
//
//   // Introduce firstTick flag to skip first decrement.
//   bool firstTick = true;
//
//   // Stop electrostimulation during pause.
//   stopElectrostimulationProcess(selectedMacAddress[selectedDeviceIndex.value]);
//
//   pauseCycleTimer[selectedDeviceIndex.value] = Timer.periodic(Duration(milliseconds: 100), (timer) {
//     if (firstTick) {
//       firstTick = false;
//       // Ensure the UI remains at the max value for the first tick.
//       remainingPauseSeconds[selectedDeviceIndex.value] = totalDurationInSeconds.toDouble();
//       return;
//     }
//     if (pauseProgress[selectedDeviceIndex.value] > 0) {
//       remainingPauseSeconds[selectedDeviceIndex.value] = (totalDurationInSeconds * pauseProgress[selectedDeviceIndex.value]).ceilToDouble();
//       pauseProgress[selectedDeviceIndex.value] -= decrementAmount;
//     } else {
//       pauseProgress[selectedDeviceIndex.value] = 0;
//       remainingPauseSeconds[selectedDeviceIndex.value] = 0;
//       pauseCycleTimer[selectedDeviceIndex.value]!.cancel();
//       startContractionTimeCycle();
//     }
//   });
// }


// int currentProgramIndex = 0;
// int elapsedTime = 0;
// int _remainingContractionTime = 0;
// int _remainingPauseTime = 0;
// CyclePhase? _currentCyclePhase;

/// Lunes
// Future<void> startContractionForMultiplePrograms(int deviceIndex, String macAddress) async {
//   if (automaticProgramValues[deviceIndex].isEmpty) {
//     print("No programs to process.");
//     return;
//   }
//   isContractionPauseCycleActive[deviceIndex] = true;
//
//   // Reset elapsedTime and cycle phase at the start of the program
//   elapsedTime[deviceIndex] = 0;
//   _currentCyclePhase[deviceIndex] = null;
//   _remainingContractionTime[deviceIndex] = 0;
//   _remainingPauseTime[deviceIndex] = 0;
//
//   for (; currentProgramIndex[deviceIndex] < automaticProgramValues[deviceIndex].length; currentProgramIndex[deviceIndex]++) {
//     var program = automaticProgramValues[deviceIndex][currentProgramIndex[deviceIndex]];
//
//     // Convert fractional minutes to seconds.
//     double durationInMinutes = program['duration'];
//     int totalProgramSeconds = (durationInMinutes * 60).toInt();
//
//     print("Starting program: ${program['subProgramName']} for $totalProgramSeconds seconds.");
//
//     // Set UI values for the given device index.
//     selectedProgramImage[deviceIndex] = program['image'];
//     selectedProgramName[deviceIndex] = program['subProgramName'];
//     frequency[deviceIndex] = program['frequency'].toInt();
//     pulse[deviceIndex] = program['pulse'].toInt();
//
//     print('InAutomatico --- Contraction Cycle --- Device 00$deviceIndex');
//     print('selectedProgramName: ${selectedProgramName[deviceIndex]}');
//     print('Frequency: ${frequency[deviceIndex]}');
//     print('Pulse: ${pulse[deviceIndex]}');
//
//     // Start the pulse cycle.
//     await startPulseCycle(program);
//
//     // Continue until the program's total duration is reached.
//     while (elapsedTime[deviceIndex] < totalProgramSeconds) {
//       // If a pause cycle was interrupted, resume it.
//       if (_currentCyclePhase[deviceIndex] == CyclePhase.pause && _remainingPauseTime[deviceIndex] > 0) {
//         print("Resuming pause cycle for $_remainingPauseTime seconds.");
//         await startAutoPauseTimeCycle(program, _remainingPauseTime[deviceIndex], deviceIndex, macAddress);
//         if (isTimerPaused[deviceIndex]) return; // pause again if needed
//         elapsedTime[deviceIndex] += _remainingPauseTime[deviceIndex];
//         _remainingPauseTime[deviceIndex] = 0;
//         _currentCyclePhase[deviceIndex] = CyclePhase.contraction;
//         continue;
//       }
//       // If a contraction cycle was interrupted, resume it.
//       else if (_currentCyclePhase[deviceIndex] == CyclePhase.contraction && _remainingContractionTime[deviceIndex] > 0) {
//         print("Resuming contraction cycle for $_remainingContractionTime seconds.");
//         await runContractionCycle(program, _remainingContractionTime[deviceIndex], deviceIndex, macAddress);
//         if (isTimerPaused[deviceIndex]) return;
//         elapsedTime[deviceIndex] += _remainingContractionTime[deviceIndex];
//         _remainingContractionTime[deviceIndex] = 0;
//         _currentCyclePhase[deviceIndex] = CyclePhase.pause;
//         if (elapsedTime[deviceIndex] >= totalProgramSeconds) break;
//         continue;
//       }
//       // If no cycle was interrupted, start a new contraction cycle.
//       else if (_currentCyclePhase[deviceIndex] == null || _currentCyclePhase[deviceIndex] == CyclePhase.contraction) {
//         int contractionDuration = program['contraction'].toInt();
//         int remainingTime = totalProgramSeconds - elapsedTime[deviceIndex];
//         int contractionRunTime = (remainingTime < contractionDuration) ? remainingTime : contractionDuration;
//         _remainingContractionTime[deviceIndex] = contractionRunTime;
//         _currentCyclePhase[deviceIndex] = CyclePhase.contraction;
//         print("Starting contraction cycle for $contractionRunTime seconds.");
//         await runContractionCycle(program, contractionRunTime, deviceIndex, macAddress);
//         if (isTimerPaused[deviceIndex]) return;
//         elapsedTime[deviceIndex] += contractionRunTime;
//         _remainingContractionTime[deviceIndex] = 0;
//         _currentCyclePhase[deviceIndex] = CyclePhase.pause;
//         if (elapsedTime[deviceIndex] >= totalProgramSeconds) break;
//       }
//       // Start a new pause cycle.
//       if (_currentCyclePhase[deviceIndex] == CyclePhase.pause) {
//         int pauseDuration = program['pause'].toInt();
//         int remainingTime = totalProgramSeconds - elapsedTime[deviceIndex];
//         int pauseRunTime = (remainingTime < pauseDuration) ? remainingTime : pauseDuration;
//         _remainingPauseTime[deviceIndex] = pauseRunTime;
//         print("Starting pause cycle for $pauseRunTime seconds.");
//         await startAutoPauseTimeCycle(program, pauseRunTime, deviceIndex, macAddress);
//         if (isTimerPaused[deviceIndex]) return;
//         elapsedTime[deviceIndex] += pauseRunTime;
//         _remainingPauseTime[deviceIndex] = 0;
//         _currentCyclePhase[deviceIndex] = CyclePhase.contraction;
//       }
//     }
//
//     // When a program finishes, reset state for the next program.
//     elapsedTime[deviceIndex] = 0;
//     _remainingContractionTime[deviceIndex] = 0;
//     _remainingPauseTime[deviceIndex] = 0;
//     _currentCyclePhase[deviceIndex] = null;
//   }
//
//   update();
//   print("All programs completed.");
// }
//
// Future<void> runContractionCycle(var program, int runTimeSeconds, int deviceIndex, String macAddress) async {
//   print("[Device $deviceIndex] Entering contraction cycle for '${program['subProgramName']}' with duration $runTimeSeconds seconds.");
//
//   // Initialize variables
//   contractionSeconds[deviceIndex] = runTimeSeconds;
//   contractionProgress[deviceIndex] = 1.0;
//   int totalDurationInSeconds = runTimeSeconds;
//   double decrementAmount = 1.0 / (totalDurationInSeconds * 10); // Decrement per 100ms
//   bool cycleCompleted = false;
//
//   // Start electrostimulation if not already on
//   if (!isElectroOn[deviceIndex]) {
//     print("[Device $deviceIndex] Starting electrostimulation.");
//     await startFullElectrostimulationTrajeProcess(
//       macAddress,
//       selectedProgramName[deviceIndex],
//       deviceIndex,
//     ).then((success) {
//       isElectroOn[deviceIndex] = true;
//       print("[Device $deviceIndex] Electrostimulation started.");
//     });
//   }
//
//   // Set initial UI values
//   remainingContractionSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
//   // Timer for the contraction cycle
//   contractionCycleTimer[deviceIndex] = Timer.periodic(Duration(milliseconds: 100), (timer) {
//     if (isTimerPaused[deviceIndex]) {
//       print("[Device $deviceIndex] Pause detected. Cancelling timer.");
//       timer.cancel();
//       _remainingContractionTime[deviceIndex] = (contractionProgress[deviceIndex] * totalDurationInSeconds).toInt();
//       print("[Device $deviceIndex] Contraction paused with $_remainingContractionTime seconds remaining.");
//       return;
//     }
//
//     // Update progress
//     if (contractionProgress[deviceIndex] > 0) {
//       contractionProgress[deviceIndex] -= decrementAmount;
//       remainingContractionSeconds[deviceIndex] = (contractionProgress[deviceIndex] * totalDurationInSeconds).ceilToDouble();
//       print("[Device $deviceIndex] Contraction tick -> progress: ${contractionProgress[deviceIndex]}, remaining seconds: ${remainingContractionSeconds[deviceIndex]}");
//     } else {
//       // Cycle completed
//       contractionProgress[deviceIndex] = 0;
//       remainingContractionSeconds[deviceIndex] = 0;
//       timer.cancel();
//       cycleCompleted = true;
//       print("[Device $deviceIndex] Contraction cycle for '${program['subProgramName']}' completed.");
//     }
//   });
//
//   // Wait for the cycle to complete
//   while (!cycleCompleted) {
//     if (isTimerPaused[deviceIndex]) {
//       print("[Device $deviceIndex] Cycle paused. Exiting loop.");
//       return;
//     }
//     await Future.delayed(Duration(milliseconds: 100));
//   }
//
//   print("[Device $deviceIndex] Contraction cycle for '${program['subProgramName']}' fully completed.");
// }
//
// Future<void> startAutoPauseTimeCycle(var program, int runTimeSeconds, int deviceIndex, String macAddress) async {
//   pauseSeconds[deviceIndex] = runTimeSeconds;
//   pauseProgress[deviceIndex] = 1.0;
//   int totalDurationInSeconds = runTimeSeconds;
//
//   if (totalDurationInSeconds == 0) {
//     print("Pause duration is zero. Skipping pause cycle.");
//     remainingPauseSeconds[deviceIndex] = 0;
//     isElectroOn[deviceIndex] = false;
//     return;
//   }
//
//   double decrementAmount = 1.0 / (totalDurationInSeconds * 10);
//   bool cycleCompleted = false;
//
//   // Stop electrostimulation during pause.
//   stopElectrostimulationProcess(macAddress, deviceIndex);
//
//   remainingPauseSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
//
//   print('remainingPauseSeconds: $remainingPauseSeconds');
//   bool firstTick = true;
//
//   pauseCycleTimer[deviceIndex] = Timer.periodic(Duration(milliseconds: 100), (timer) {
//     if (isTimerPaused[deviceIndex]) {
//       timer.cancel();
//       _remainingPauseTime[deviceIndex] = (pauseProgress[deviceIndex] * totalDurationInSeconds).toInt();
//       print("Pause cycle paused with $_remainingPauseTime seconds remaining.");
//       return;
//     }
//     if (firstTick) {
//       firstTick = false;
//       remainingPauseSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
//       return;
//     }
//     if (pauseProgress[deviceIndex] > 0) {
//       pauseProgress[deviceIndex] -= decrementAmount;
//       remainingPauseSeconds[deviceIndex] = (pauseProgress[deviceIndex] * totalDurationInSeconds).ceilToDouble();
//     } else {
//       pauseProgress[deviceIndex] = 0;
//       remainingPauseSeconds[deviceIndex] = 0;
//       timer.cancel();
//       cycleCompleted = true;
//     }
//   });
//
//   while (!cycleCompleted) {
//     if (isTimerPaused[deviceIndex]) return;
//     await Future.delayed(Duration(milliseconds: 100));
//   }
//   print("Pause cycle for ${program['subProgramName']} completed.");
// }
/// Lunes///

// /// Auto Programs
// /// Best version
// Future<void> startContractionForMultiplePrograms(int deviceIndex, String macAddress) async {
//   if (automaticProgramValues.isEmpty) {
//     print("No programs to process.");
//     return;
//   }
//   isContractionPauseCycleActive[deviceIndex] = true;
//
//   // Reset elapsedTime and cycle phase at the start of the program
//   elapsedTime = 0;
//   _currentCyclePhase = null;
//   _remainingContractionTime = 0;
//   _remainingPauseTime = 0;
//
//   for (; currentProgramIndex < automaticProgramValues.length; currentProgramIndex++) {
//     var program = automaticProgramValues[currentProgramIndex];
//
//     // Convert fractional minutes to seconds.
//     double durationInMinutes = program['duration'];
//     int totalProgramSeconds = (durationInMinutes * 60).toInt();
//
//     print("Starting program: ${program['subProgramName']} for $totalProgramSeconds seconds.");
//
//     // Set UI values for the given device index.
//     selectedProgramImage[deviceIndex] = program['image'];
//     selectedProgramName[deviceIndex] = program['subProgramName'];
//     frequency[deviceIndex] = program['frequency'].toInt();
//     pulse[deviceIndex] = program['pulse'].toInt();
//
//     print('InAutomatico --- Contraction Cycle --- Device 00$deviceIndex');
//     print('selectedProgramName: ${selectedProgramName[deviceIndex]}');
//     print('Frequency: ${frequency[deviceIndex]}');
//     print('Pulse: ${pulse[deviceIndex]}');
//
//     // Start the pulse cycle.
//     await startPulseCycle(program);
//
//     // Continue until the program's total duration is reached.
//     while (elapsedTime < totalProgramSeconds) {
//       // If a pause cycle was interrupted, resume it.
//       if (_currentCyclePhase == CyclePhase.pause && _remainingPauseTime > 0) {
//         print("Resuming pause cycle for $_remainingPauseTime seconds.");
//         await startAutoPauseTimeCycle(program, _remainingPauseTime, deviceIndex);
//         if (isTimerPaused[deviceIndex]) return; // pause again if needed
//         elapsedTime += _remainingPauseTime;
//         _remainingPauseTime = 0;
//         _currentCyclePhase = CyclePhase.contraction;
//         continue;
//       }
//       // If a contraction cycle was interrupted, resume it.
//       else if (_currentCyclePhase == CyclePhase.contraction && _remainingContractionTime > 0) {
//         print("Resuming contraction cycle for $_remainingContractionTime seconds.");
//         await runContractionCycle(program, _remainingContractionTime, deviceIndex);
//         if (isTimerPaused[deviceIndex]) return;
//         elapsedTime += _remainingContractionTime;
//         _remainingContractionTime = 0;
//         _currentCyclePhase = CyclePhase.pause;
//         if (elapsedTime >= totalProgramSeconds) break;
//         continue;
//       }
//       // If no cycle was interrupted, start a new contraction cycle.
//       else if (_currentCyclePhase == null || _currentCyclePhase == CyclePhase.contraction) {
//         int contractionDuration = program['contraction'].toInt();
//         int remainingTime = totalProgramSeconds - elapsedTime;
//         int contractionRunTime = (remainingTime < contractionDuration) ? remainingTime : contractionDuration;
//         _remainingContractionTime = contractionRunTime;
//         _currentCyclePhase = CyclePhase.contraction;
//         print("Starting contraction cycle for $contractionRunTime seconds.");
//         await runContractionCycle(program, contractionRunTime, deviceIndex);
//         if (isTimerPaused[deviceIndex]) return;
//         elapsedTime += contractionRunTime;
//         _remainingContractionTime = 0;
//         _currentCyclePhase = CyclePhase.pause;
//         if (elapsedTime >= totalProgramSeconds) break;
//       }
//       // Start a new pause cycle.
//       if (_currentCyclePhase == CyclePhase.pause) {
//         int pauseDuration = program['pause'].toInt();
//         int remainingTime = totalProgramSeconds - elapsedTime;
//         int pauseRunTime = (remainingTime < pauseDuration) ? remainingTime : pauseDuration;
//         _remainingPauseTime = pauseRunTime;
//         print("Starting pause cycle for $pauseRunTime seconds.");
//         await startAutoPauseTimeCycle(program, pauseRunTime, deviceIndex);
//         if (isTimerPaused[deviceIndex]) return;
//         elapsedTime += pauseRunTime;
//         _remainingPauseTime = 0;
//         _currentCyclePhase = CyclePhase.contraction;
//       }
//     }
//
//     // When a program finishes, reset state for the next program.
//     elapsedTime = 0;
//     _remainingContractionTime = 0;
//     _remainingPauseTime = 0;
//     _currentCyclePhase = null;
//   }
//
//   update();
//   print("All programs completed.");
// }
//
// /// Modified contraction cycle .
// /// /// Best version
// Future<void> runContractionCycle(var program, int runTimeSeconds, int deviceIndex) async {
//   print("[Device $deviceIndex] Entering contraction cycle for '${program['subProgramName']}' with duration $runTimeSeconds seconds.");
//
//   // Initialize variables
//   contractionSeconds[deviceIndex] = runTimeSeconds;
//   contractionProgress[deviceIndex] = 1.0;
//   int totalDurationInSeconds = runTimeSeconds;
//   double decrementAmount = 1.0 / (totalDurationInSeconds * 10); // Decrement per 100ms
//   bool cycleCompleted = false;
//
//   // Start electrostimulation if not already on
//   if (!isElectroOn[deviceIndex]) {
//     print("[Device $deviceIndex] Starting electrostimulation.");
//     await startFullElectrostimulationTrajeProcess(
//       selectedMacAddress[deviceIndex],
//       selectedProgramName[deviceIndex],
//       deviceIndex,
//     ).then((success) {
//       isElectroOn[deviceIndex] = true;
//       print("[Device $deviceIndex] Electrostimulation started.");
//     });
//   }
//
//   // Set initial UI values
//   remainingContractionSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
//
//   // Timer for the contraction cycle
//   contractionCycleTimer[deviceIndex] = Timer.periodic(Duration(milliseconds: 100), (timer) {
//     if (isTimerPaused[deviceIndex]) {
//       print("[Device $deviceIndex] Pause detected. Cancelling timer.");
//       timer.cancel();
//       _remainingContractionTime = (contractionProgress[deviceIndex] * totalDurationInSeconds).toInt();
//       print("[Device $deviceIndex] Contraction paused with $_remainingContractionTime seconds remaining.");
//       return;
//     }
//
//     // Update progress
//     if (contractionProgress[deviceIndex] > 0) {
//       contractionProgress[deviceIndex] -= decrementAmount;
//       remainingContractionSeconds[deviceIndex] = (contractionProgress[deviceIndex] * totalDurationInSeconds).ceilToDouble();
//       print("[Device $deviceIndex] Contraction tick -> progress: ${contractionProgress[deviceIndex]}, remaining seconds: ${remainingContractionSeconds[deviceIndex]}");
//     } else {
//       // Cycle completed
//       contractionProgress[deviceIndex] = 0;
//       remainingContractionSeconds[deviceIndex] = 0;
//       timer.cancel();
//       cycleCompleted = true;
//       print("[Device $deviceIndex] Contraction cycle for '${program['subProgramName']}' completed.");
//     }
//   });
//
//   // Wait for the cycle to complete
//   while (!cycleCompleted) {
//     if (isTimerPaused[deviceIndex]) {
//       print("[Device $deviceIndex] Cycle paused. Exiting loop.");
//       return;
//     }
//     await Future.delayed(Duration(milliseconds: 100));
//   }
//
//   print("[Device $deviceIndex] Contraction cycle for '${program['subProgramName']}' fully completed.");
// }
//
// /// Modified pause cycle – now using deviceIndex.
// /// /// Best version
// Future<void> startAutoPauseTimeCycle(var program, int runTimeSeconds, int deviceIndex) async {
//   pauseSeconds[deviceIndex] = runTimeSeconds;
//   pauseProgress[deviceIndex] = 1.0;
//   int totalDurationInSeconds = runTimeSeconds;
//
//   if (totalDurationInSeconds == 0) {
//     print("Pause duration is zero. Skipping pause cycle.");
//     remainingPauseSeconds[deviceIndex] = 0;
//     isElectroOn[deviceIndex] = false;
//     return;
//   }
//
//   double decrementAmount = 1.0 / (totalDurationInSeconds * 10);
//   bool cycleCompleted = false;
//
//   // Stop electrostimulation during pause.
//   stopElectrostimulationProcess(selectedMacAddress[deviceIndex], deviceIndex);
//
//   remainingPauseSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
//
//   bool firstTick = true;
//
//   pauseCycleTimer[deviceIndex] = Timer.periodic(Duration(milliseconds: 100), (timer) {
//     if (isTimerPaused[deviceIndex]) {
//       timer.cancel();
//       _remainingPauseTime = (pauseProgress[deviceIndex] * totalDurationInSeconds).toInt();
//       print("Pause cycle paused with $_remainingPauseTime seconds remaining.");
//       return;
//     }
//     if (firstTick) {
//       firstTick = false;
//       remainingPauseSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
//       return;
//     }
//     if (pauseProgress[deviceIndex] > 0) {
//       pauseProgress[deviceIndex] -= decrementAmount;
//       remainingPauseSeconds[deviceIndex] = (pauseProgress[deviceIndex] * totalDurationInSeconds).ceilToDouble();
//     } else {
//       pauseProgress[deviceIndex] = 0;
//       remainingPauseSeconds[deviceIndex] = 0;
//       timer.cancel();
//       cycleCompleted = true;
//     }
//   });
//
//   while (!cycleCompleted) {
//     if (isTimerPaused[deviceIndex]) return;
//     await Future.delayed(Duration(milliseconds: 100));
//   }
//   print("Pause cycle for ${program['subProgramName']} completed.");
// }

// Future<void> startContractionForMultiplePrograms(int deviceIndex) async {
//   if (automaticProgramValues.isEmpty) {
//     print("No programs to process.");
//     return;
//   }
//   isContractionPauseCycleActive[deviceIndex] = true;
//
//   // DO NOT reset elapsedTime here if we're resuming mid-program.
//   for (; currentProgramIndex < automaticProgramValues.length; currentProgramIndex++) {
//     var program = automaticProgramValues[currentProgramIndex];
//
//     // Convert fractional minutes to seconds.
//     double durationInMinutes = program['duration'];
//     int totalProgramSeconds = (durationInMinutes * 60).toInt();
//
//     print("Starting program: ${program['subProgramName']} for $totalProgramSeconds seconds.");
//
//     // Set UI values for the given device index.
//     selectedProgramImage[deviceIndex] = program['image'];
//     selectedProgramName[deviceIndex] = program['subProgramName'];
//     frequency[deviceIndex] = program['frequency'].toInt();
//     pulse[deviceIndex] = program['pulse'].toInt();
//
//     print('InAutomatico --- Contraction Cycle --- Device 00$deviceIndex');
//     print('selectedProgramName: ${selectedProgramName[deviceIndex]}');
//     print('Frequency: ${frequency[deviceIndex]}');
//     print('Pulse: ${pulse[deviceIndex]}');
//
//
//     // Start the pulse cycle.
//     await startPulseCycle(program);
//
//     // Continue until the program's total duration is reached.
//     while (elapsedTime < totalProgramSeconds) {
//       // If a pause cycle was interrupted, resume it.
//       if (_currentCyclePhase == CyclePhase.pause && _remainingPauseTime > 0) {
//         print("Resuming pause cycle for $_remainingPauseTime seconds.");
//         await startAutoPauseTimeCycle(program, _remainingPauseTime, deviceIndex);
//         if (isTimerPaused[deviceIndex]) return; // pause again if needed
//         elapsedTime += _remainingPauseTime;
//         _remainingPauseTime = 0;
//         _currentCyclePhase = CyclePhase.contraction;
//         continue;
//       }
//       // If a contraction cycle was interrupted, resume it.
//       else if (_currentCyclePhase == CyclePhase.contraction && _remainingContractionTime > 0) {
//         print("Resuming contraction cycle for $_remainingContractionTime seconds.");
//         await runContractionCycle(program, _remainingContractionTime, deviceIndex);
//         if (isTimerPaused[deviceIndex]) return;
//         elapsedTime += _remainingContractionTime;
//         _remainingContractionTime = 0;
//         _currentCyclePhase = CyclePhase.pause;
//         if (elapsedTime >= totalProgramSeconds) break;
//         continue;
//       }
//       // If no cycle was interrupted, start a new contraction cycle.
//       else if (_currentCyclePhase == null || _currentCyclePhase == CyclePhase.contraction) {
//         int contractionDuration = program['contraction'].toInt();
//         int remainingTime = totalProgramSeconds - elapsedTime;
//         int contractionRunTime = (remainingTime < contractionDuration) ? remainingTime : contractionDuration;
//         _remainingContractionTime = contractionRunTime;
//         _currentCyclePhase = CyclePhase.contraction;
//         print("Starting contraction cycle for $contractionRunTime seconds.");
//         await runContractionCycle(program, contractionRunTime, deviceIndex);
//         if (isTimerPaused[deviceIndex]) return;
//         elapsedTime += contractionRunTime;
//         _remainingContractionTime = 0;
//         _currentCyclePhase = CyclePhase.pause;
//         if (elapsedTime >= totalProgramSeconds) break;
//       }
//       // Start a new pause cycle.
//       if (_currentCyclePhase == CyclePhase.pause) {
//         int pauseDuration = program['pause'].toInt();
//         int remainingTime = totalProgramSeconds - elapsedTime;
//         int pauseRunTime = (remainingTime < pauseDuration) ? remainingTime : pauseDuration;
//         _remainingPauseTime = pauseRunTime;
//         print("Starting pause cycle for $pauseRunTime seconds.");
//         await startAutoPauseTimeCycle(program, pauseRunTime, deviceIndex);
//         if (isTimerPaused[deviceIndex]) return;
//         elapsedTime += pauseRunTime;
//         _remainingPauseTime = 0;
//         _currentCyclePhase = CyclePhase.contraction;
//       }
//     }
//
//     // When a program finishes, reset state for the next program.
//     elapsedTime = 0;
//     _remainingContractionTime = 0;
//     _remainingPauseTime = 0;
//     _currentCyclePhase = null;
//   }
//
//   update();
//   print("All programs completed.");
// }


// Future<void> runContractionCycle(var program, int runTimeSeconds, int deviceIndex) async {
//   print("[Device $deviceIndex] Entering contraction cycle for '${program['subProgramName']}' with duration $runTimeSeconds seconds.");
//
//   // Initialize variables
//   contractionSeconds[deviceIndex] = runTimeSeconds;
//   contractionProgress[deviceIndex] = 1.0;
//   int totalDurationInSeconds = runTimeSeconds;
//   double decrementAmount = 1.0 / (totalDurationInSeconds * 10); // Decrement per 100ms
//   bool cycleCompleted = false;
//
//   // Start electrostimulation if not already on
//   if (!isElectroOn[deviceIndex]) {
//     print("[Device $deviceIndex] Starting electrostimulation.");
//     await startFullElectrostimulationTrajeProcess(
//       selectedMacAddress[deviceIndex],
//       selectedProgramName[deviceIndex],
//       deviceIndex,
//     ).then((success) {
//       isElectroOn[deviceIndex] = true;
//       print("[Device $deviceIndex] Electrostimulation started.");
//     });
//   }
//
//   // Set initial UI values
//   remainingContractionSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
//
//   // Timer for the contraction cycle
//   contractionCycleTimer[deviceIndex] = Timer.periodic(Duration(milliseconds: 100), (timer) {
//     if (isTimerPaused[deviceIndex]) {
//       print("[Device $deviceIndex] Pause detected. Cancelling timer.");
//       timer.cancel();
//       _remainingContractionTime = (contractionProgress[deviceIndex] * totalDurationInSeconds).toInt();
//       print("[Device $deviceIndex] Contraction paused with $_remainingContractionTime seconds remaining.");
//       return;
//     }
//
//     // Update progress
//     if (contractionProgress[deviceIndex] > 0) {
//       contractionProgress[deviceIndex] -= decrementAmount;
//       remainingContractionSeconds[deviceIndex] = (contractionProgress[deviceIndex] * totalDurationInSeconds).ceilToDouble();
//       print("[Device $deviceIndex] Contraction tick -> progress: ${contractionProgress[deviceIndex]}, remaining seconds: ${remainingContractionSeconds[deviceIndex]}");
//     } else {
//       // Cycle completed
//       contractionProgress[deviceIndex] = 0;
//       remainingContractionSeconds[deviceIndex] = 0;
//       timer.cancel();
//       cycleCompleted = true;
//       print("[Device $deviceIndex] Contraction cycle for '${program['subProgramName']}' completed.");
//     }
//   });
//
//   // Wait for the cycle to complete
//   while (!cycleCompleted) {
//     if (isTimerPaused[deviceIndex]) {
//       print("[Device $deviceIndex] Cycle paused. Exiting loop.");
//       return;
//     }
//     await Future.delayed(Duration(milliseconds: 100));
//   }
//
//   print("[Device $deviceIndex] Contraction cycle for '${program['subProgramName']}' fully completed.");
// }
// Future<void> runContractionCycle(var program, int runTimeSeconds, int deviceIndex) async {
//   contractionSeconds[deviceIndex] = runTimeSeconds;
//   contractionProgress[deviceIndex] = 1.0;
//   int totalDurationInSeconds = runTimeSeconds;
//   double decrementAmount = 1.0 / (totalDurationInSeconds * 10);
//   bool cycleCompleted = false;
//
//   // Start electrostimulation if not already on.
//   if (!isElectroOn[deviceIndex]) {
//     await startFullElectrostimulationTrajeProcess(
//         selectedMacAddress[deviceIndex],
//         selectedProgramName[deviceIndex],
//         deviceIndex
//     ).then((success) {
//       isElectroOn[deviceIndex] = true;
//     });
//   }
//
//   // Immediately set UI to maximum.
//   remainingContractionSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
//
//   bool firstTick = true;
//
//   contractionCycleTimer[deviceIndex] = Timer.periodic(Duration(milliseconds: 100), (timer) {
//     if (isTimerPaused[deviceIndex]) {
//       timer.cancel();
//       _remainingContractionTime = (contractionProgress[deviceIndex] * totalDurationInSeconds).toInt();
//       print("Contraction paused with $_remainingContractionTime seconds remaining.");
//       return;
//     }
//     if (firstTick) {
//       firstTick = false;
//       remainingContractionSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
//       return;
//     }
//     if (contractionProgress[deviceIndex] > 0) {
//       contractionProgress[deviceIndex] -= decrementAmount;
//       remainingContractionSeconds[deviceIndex] =
//           (contractionProgress[deviceIndex] * totalDurationInSeconds).ceilToDouble();
//     } else {
//       contractionProgress[deviceIndex] = 0;
//       remainingContractionSeconds[deviceIndex] = 0;
//       timer.cancel();
//       cycleCompleted = true;
//     }
//   });
//
//   while (!cycleCompleted) {
//     if (isTimerPaused[deviceIndex]) return;
//     await Future.delayed(Duration(milliseconds: 100));
//   }
//   print("Contraction cycle for ${program['subProgramName']} completed.");
// }
// Future<void> runContractionCycle(var program, int runTimeSeconds, int deviceIndex) async {
//   print("Starting contraction cycle for ${program['subProgramName']} for $runTimeSeconds seconds on device $deviceIndex.");
//
//   // Initialize variables
//   contractionSeconds[deviceIndex] = runTimeSeconds;
//   contractionProgress[deviceIndex] = 1.0;
//   int totalDurationInSeconds = runTimeSeconds;
//   double decrementAmount = 1.0 / (totalDurationInSeconds * 10); // Decrement per 100ms
//   bool cycleCompleted = false;
//
//   // Start electrostimulation if not already on
//   if (!isElectroOn[deviceIndex]) {
//     print("Starting electrostimulation for device $deviceIndex.");
//     await startFullElectrostimulationTrajeProcess(
//       selectedMacAddress[deviceIndex],
//       selectedProgramName[deviceIndex],
//       deviceIndex,
//     ).then((success) {
//       isElectroOn[deviceIndex] = true;
//       print("Electrostimulation started for device $deviceIndex.");
//     });
//   }
//
//   // Set initial UI values
//   remainingContractionSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
//
//   // Timer for the contraction cycle
//   contractionCycleTimer[deviceIndex] = Timer.periodic(Duration(milliseconds: 100), (timer) {
//     if (isTimerPaused[deviceIndex]) {
//       print("Pause detected for device $deviceIndex. Cancelling timer.");
//       timer.cancel();
//       _remainingContractionTime = (contractionProgress[deviceIndex] * totalDurationInSeconds).toInt();
//       print("Contraction paused with $_remainingContractionTime seconds remaining.");
//       return;
//     }
//
//     // Update progress
//     if (contractionProgress[deviceIndex] > 0) {
//       contractionProgress[deviceIndex] -= decrementAmount;
//       remainingContractionSeconds[deviceIndex] = (contractionProgress[deviceIndex] * totalDurationInSeconds).ceilToDouble();
//       print("Progress for device $deviceIndex: ${contractionProgress[deviceIndex]}");
//     } else {
//       // Cycle completed
//       contractionProgress[deviceIndex] = 0;
//       remainingContractionSeconds[deviceIndex] = 0;
//       timer.cancel();
//       cycleCompleted = true;
//       print("Contraction cycle completed for device $deviceIndex.");
//     }
//   });
//
//   // Wait for the cycle to complete
//   while (!cycleCompleted) {
//     if (isTimerPaused[deviceIndex]) {
//       print("Cycle paused for device $deviceIndex. Exiting loop.");
//       return;
//     }
//     await Future.delayed(Duration(milliseconds: 100));
//   }
//
//   print("Contraction cycle for ${program['subProgramName']} fully completed for device $deviceIndex.");
// }




// Future<void> startContractionForMultiplePrograms(int deviceIndex) async {
//   if (automaticProgramValues.isEmpty) {
//     print("No programs to process.");
//     return;
//   }
//   isContractionPauseCycleActive[selectedDeviceIndex.value] = true;
//
//   // DO NOT reset elapsedTime here if we're resuming mid-program.
//   for (; currentProgramIndex < automaticProgramValues.length; currentProgramIndex++) {
//     var program = automaticProgramValues[currentProgramIndex];
//
//     // Convert fractional minutes to seconds.
//     double durationInMinutes = program['duration'];
//     int totalProgramSeconds = (durationInMinutes * 60).toInt();
//
//     print("Starting program: ${program['subProgramName']} for $totalProgramSeconds seconds.");
//
//     // Set UI values.
//     selectedProgramImage[selectedDeviceIndex.value] = program['image'];
//     selectedProgramName[selectedDeviceIndex.value] = program['subProgramName'];
//     frequency[selectedDeviceIndex.value] = program['frequency'].toInt();
//     pulse[selectedDeviceIndex.value] = program['pulse'].toInt();
//
//     // Start the pulse cycle.
//     await startPulseCycle(program);
//
//     // Continue until the program's total duration is reached.
//     while (elapsedTime < totalProgramSeconds) {
//       // If a pause cycle was interrupted, resume it.
//       if (_currentCyclePhase == CyclePhase.pause && _remainingPauseTime > 0) {
//         print("Resuming pause cycle for $_remainingPauseTime seconds.");
//         await startAutoPauseTimeCycle(program, _remainingPauseTime);
//         if (isTimerPaused[selectedDeviceIndex.value]) return; // pause again if needed
//         elapsedTime += _remainingPauseTime;
//         _remainingPauseTime = 0;
//         _currentCyclePhase = CyclePhase.contraction;
//         continue;
//       }
//       // If a contraction cycle was interrupted, resume it.
//       else if (_currentCyclePhase == CyclePhase.contraction && _remainingContractionTime > 0) {
//         print("Resuming contraction cycle for $_remainingContractionTime seconds.");
//         await runContractionCycle(program, _remainingContractionTime);
//         if (isTimerPaused[selectedDeviceIndex.value]) return;
//         elapsedTime += _remainingContractionTime;
//         _remainingContractionTime = 0;
//         _currentCyclePhase = CyclePhase.pause;
//         if (elapsedTime >= totalProgramSeconds) break;
//         continue;
//       }
//       // If no cycle was interrupted, start a new contraction cycle.
//       else if (_currentCyclePhase == null || _currentCyclePhase == CyclePhase.contraction) {
//         int contractionDuration = program['contraction'].toInt();
//         int remainingTime = totalProgramSeconds - elapsedTime;
//         int contractionRunTime = (remainingTime < contractionDuration) ? remainingTime : contractionDuration;
//         _remainingContractionTime = contractionRunTime;
//         _currentCyclePhase = CyclePhase.contraction;
//         print("Starting contraction cycle for $contractionRunTime seconds.");
//         await runContractionCycle(program, contractionRunTime);
//         if (isTimerPaused[selectedDeviceIndex.value]) return;
//         elapsedTime += contractionRunTime;
//         _remainingContractionTime = 0;
//         _currentCyclePhase = CyclePhase.pause;
//         if (elapsedTime >= totalProgramSeconds) break;
//       }
//       // Start a new pause cycle.
//       if (_currentCyclePhase == CyclePhase.pause) {
//         int pauseDuration = program['pause'].toInt();
//         int remainingTime = totalProgramSeconds - elapsedTime;
//         int pauseRunTime = (remainingTime < pauseDuration) ? remainingTime : pauseDuration;
//         _remainingPauseTime = pauseRunTime;
//         print("Starting pause cycle for $pauseRunTime seconds.");
//         await startAutoPauseTimeCycle(program, pauseRunTime);
//         if (isTimerPaused[selectedDeviceIndex.value]) return;
//         elapsedTime += pauseRunTime;
//         _remainingPauseTime = 0;
//         _currentCyclePhase = CyclePhase.contraction;
//       }
//     }
//
//     // When a program finishes, reset state for the next program.
//     elapsedTime = 0;
//     _remainingContractionTime = 0;
//     _remainingPauseTime = 0;
//     _currentCyclePhase = null;
//   }
//
//   update();
//   print("All programs completed.");
// }
//
// /// Modified contraction cycle.
// Future<void> runContractionCycle(var program, int runTimeSeconds) async {
//   contractionSeconds[selectedDeviceIndex.value] = runTimeSeconds;
//   contractionProgress[selectedDeviceIndex.value] = 1.0;
//   int totalDurationInSeconds = runTimeSeconds;
//   double decrementAmount = 1.0 / (totalDurationInSeconds * 10);
//   bool cycleCompleted = false;
//
//   // Start electrostimulation if not already on.
//   if (!isElectroOn[selectedDeviceIndex.value]) {
//     await startFullElectrostimulationTrajeProcess(
//         selectedMacAddress[selectedDeviceIndex.value],
//         selectedProgramName[selectedDeviceIndex.value]
//     ).then((success) {
//       isElectroOn[selectedDeviceIndex.value] = true;
//     });
//   }
//
//   // Immediately set UI to maximum.
//   remainingContractionSeconds[selectedDeviceIndex.value] = totalDurationInSeconds.toDouble();
//
//   bool firstTick = true;
//
//   contractionCycleTimer[selectedDeviceIndex.value] = Timer.periodic(Duration(milliseconds: 100), (timer) {
//     if (isTimerPaused[selectedDeviceIndex.value]) {
//       timer.cancel();
//       _remainingContractionTime = (contractionProgress[selectedDeviceIndex.value] * totalDurationInSeconds).toInt();
//       print("Contraction paused with $_remainingContractionTime seconds remaining.");
//       return;
//     }
//     if (firstTick) {
//       firstTick = false;
//       remainingContractionSeconds[selectedDeviceIndex.value] = totalDurationInSeconds.toDouble();
//       return;
//     }
//     if (contractionProgress[selectedDeviceIndex.value] > 0) {
//       contractionProgress[selectedDeviceIndex.value] -= decrementAmount;
//       remainingContractionSeconds[selectedDeviceIndex.value] =
//           (contractionProgress[selectedDeviceIndex.value] * totalDurationInSeconds).ceilToDouble();
//     } else {
//       contractionProgress[selectedDeviceIndex.value] = 0;
//       remainingContractionSeconds[selectedDeviceIndex.value] = 0;
//       timer.cancel();
//       cycleCompleted = true;
//     }
//   });
//
//   while (!cycleCompleted) {
//     if (isTimerPaused[selectedDeviceIndex.value]) return;
//     await Future.delayed(Duration(milliseconds: 100));
//   }
//   print("Contraction cycle for ${program['subProgramName']} completed.");
// }
//
// /// Modified pause cycle.
// Future<void> startAutoPauseTimeCycle(var program, int runTimeSeconds) async {
//   pauseSeconds[selectedDeviceIndex.value] = runTimeSeconds;
//   pauseProgress[selectedDeviceIndex.value] = 1.0;
//   int totalDurationInSeconds = runTimeSeconds;
//   double decrementAmount = 1.0 / (totalDurationInSeconds * 10);
//   bool cycleCompleted = false;
//
//   // Stop electrostimulation during pause.
//   stopElectrostimulationProcess(selectedMacAddress[selectedDeviceIndex.value]);
//
//   remainingPauseSeconds[selectedDeviceIndex.value] = totalDurationInSeconds.toDouble();
//
//   bool firstTick = true;
//
//   pauseCycleTimer[selectedDeviceIndex.value] = Timer.periodic(Duration(milliseconds: 100), (timer) {
//     if (isTimerPaused[selectedDeviceIndex.value]) {
//       timer.cancel();
//       _remainingPauseTime = (pauseProgress[selectedDeviceIndex.value] * totalDurationInSeconds).toInt();
//       print("Pause cycle paused with $_remainingPauseTime seconds remaining.");
//       return;
//     }
//     if (firstTick) {
//       firstTick = false;
//       remainingPauseSeconds[selectedDeviceIndex.value] = totalDurationInSeconds.toDouble();
//       return;
//     }
//     if (pauseProgress[selectedDeviceIndex.value] > 0) {
//       pauseProgress[selectedDeviceIndex.value] -= decrementAmount;
//       remainingPauseSeconds[selectedDeviceIndex.value] = (pauseProgress[selectedDeviceIndex.value] * totalDurationInSeconds).ceilToDouble();
//     } else {
//       pauseProgress[selectedDeviceIndex.value] = 0;
//       remainingPauseSeconds[selectedDeviceIndex.value] = 0;
//       timer.cancel();
//       cycleCompleted = true;
//     }
//   });
//
//   while (!cycleCompleted) {
//     if (isTimerPaused[selectedDeviceIndex.value]) return;
//     await Future.delayed(Duration(milliseconds: 100));
//   }
//   print("Pause cycle for ${program['subProgramName']} completed.");
// }