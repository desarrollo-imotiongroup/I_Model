import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Change to your desired color
      statusBarIconBrightness: Brightness.dark, // For white icons
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(MaterialApp(
      home: TapBlockerButton(),
    ));
  });
}

class TapBlockerButton extends StatefulWidget {
  @override
  _TapBlockerButtonState createState() => _TapBlockerButtonState();
}

class _TapBlockerButtonState extends State<TapBlockerButton> {
  List<DateTime> _tapTimes = [];
  bool _isBlocked = false;

  void _onTap() {
    if (_isBlocked) return;

    final now = DateTime.now();
    _tapTimes.add(now);

    // Remove taps that are older than 2 seconds
    _tapTimes = _tapTimes.where((time) => now.difference(time).inMilliseconds < 2000).toList();

    // If there are 8 or more taps in the last 2 seconds, block the user
    if (_tapTimes.length >= 8) {
      setState(() {
        _isBlocked = true;
      });
      // Disable tapping for 2 seconds
      Timer(Duration(seconds: 2), () {
        setState(() {
          _isBlocked = false;
          _tapTimes.clear(); // Reset the tap history after the block
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isBlocked ? null : _onTap,
      child: Text(_isBlocked ? 'Please wait...' : 'Tap me'),
    );
  }
}
