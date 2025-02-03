import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/strings.dart';

class LineGraph extends StatelessWidget {
  final List<FlSpot> flSpotList;

  const LineGraph({
    required this.flSpotList,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.6,
      child: LineChart(
        lineGraphData(),
      ),
    );
  }

  LineChartData lineGraphData() {
    List<Color> gradientColors = [
      Color(0xFFD080AE),
      Color(0xFFD080AE).withValues(alpha: 0.6)
    ];

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        /// Horizontal graph lines
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        /// Vertical graph lines
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 70,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: flSpotList,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 6.sp,
    );

    Widget widget;

    // Use Text with line breaks instead of Column
    switch (value.toInt()) {
      case 0:
        widget =  Text('01/01/2025', style: style);
        break;
      case 1:
        widget =  Text('02/01/2025', style: style);
        break;
      case 2:
        widget =  Text('03/01/2025', style: style);
        break;
      case 3:
        widget =  Text('04/01/2025', style: style);
        break;
      case 4:
        widget =  Text('05/01/2025', style: style);
        break;
      case 5:
        widget =  Text('06/01/2025', style: style);
        break;
      case 6:
        widget =  Text('07/01/2025', style: style);
        break;
      case 7:
        widget =  Text('08/01/2025', style: style);
        break;
      case 8:
        widget =  Text('09/01/2025', style: style);
        break;
      case 9:
        widget =  Text('10/01/2025', style: style); // Single Text widget with line break
        break;
      default:
        widget =  Text('Unknown Date', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: widget, // Returning the Text widget
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 7.sp,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = Strings.excellent;
        break;
      case 1:
        text = Strings.veryGood;
        break;
      case 2:
        text = Strings.normal;
        break;
      case 3:
        text = Strings.nearNormal;
        break;
      case 4:
        text = Strings.toMonitor;
        break;
      case 5:
        text = Strings.toTreat;
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
