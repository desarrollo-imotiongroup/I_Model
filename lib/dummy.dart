import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Data Table Example'),
        ),
        body: MyDataTable(),
      ),
    );
  }
}

class MyDataTable extends StatelessWidget {
  // Example data (replace with your dynamic data)
  final List<Map<String, String>> data = [
    {'mci': '354532F223A', 'type': 'BT', 'status': 'ACTIVO'},
    {'mci': '354532F223A', 'type': 'BLE', 'status': 'ACTIVO'},
    {'mci': '', 'type': '', 'status': ''},
    {'mci': '', 'type': '', 'status': ''},
    {'mci': '', 'type': '', 'status': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Table header
          DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Center(child: Text('MCI', textAlign: TextAlign.center,))),
              DataColumn(label: Text('TIPO')),
              DataColumn(label: Text('ESTADO')),
            ],
            rows: List.generate(
              data.length,
                  (index) => DataRow(
                cells: [
                  DataCell(Center(child: Text(data[index]['mci'] ?? ''))),
                  DataCell(Text(data[index]['type'] ?? '')),
                  DataCell(Text(data[index]['status'] ?? '')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
