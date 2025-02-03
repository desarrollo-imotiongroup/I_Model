import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VerticalTabBarWithIndexedStack(),
    );
  }
}

class VerticalTabBarWithIndexedStack extends StatefulWidget {
  @override
  _VerticalTabBarWithIndexedStackState createState() =>
      _VerticalTabBarWithIndexedStackState();
}

class _VerticalTabBarWithIndexedStackState
    extends State<VerticalTabBarWithIndexedStack> {
  int _selectedIndex = 0; // To keep track of the selected tab

  List<Widget> _tabPages = [
    Center(child: Text("Content of Tab 1")),
    Center(child: Text("Content of Tab 2")),
    Center(child: Text("Content of Tab 3")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vertical TabBar with IndexedStack")),
      body: Row(
        children: [
          // Vertical TabBar on the left
          Container(
            width: 150, // Adjust the width of the vertical tab bar
            child: Column(
              children: [
                ListTile(
                  title: Text("Tab 1"),
                  onTap: () => _onTabSelected(0),
                  selected: _selectedIndex == 0,
                ),
                ListTile(
                  title: Text("Tab 2"),
                  onTap: () => _onTabSelected(1),
                  selected: _selectedIndex == 1,
                ),
                ListTile(
                  title: Text("Tab 3"),
                  onTap: () => _onTabSelected(2),
                  selected: _selectedIndex == 2,
                ),
              ],
            ),
          ),
          // Content displayed next to the TabBar using IndexedStack
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _tabPages,
            ),
          ),
        ],
      ),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
