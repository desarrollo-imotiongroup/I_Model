import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Dialog with Dropdown'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showCustomDialog(context);
          },
          child: Text('Show Custom Dialog'),
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,  // 90% of screen width
            height: MediaQuery.of(context).size.height * 0.9,  // 90% of screen height
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Custom Dialog with Dropdown",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Select an option from the dropdown below:",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownWidget(),
                  ),
                  // Add more widgets here as needed
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DropdownWidget extends StatefulWidget {
  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? _selectedOption;
  final List<String> _options = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedOption,
      hint: Text("Select Option"),
      isExpanded: true,
      items: _options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedOption = newValue;
        });
      },
    );
  }
}
