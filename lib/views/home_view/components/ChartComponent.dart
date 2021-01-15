import 'dart:math';

import 'package:Videotheque/Globals.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

class ChartComponent extends StatelessWidget {

  final Map<double, double> data;

  ChartComponent(this.data);

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
        getDrawingVerticalLine: (value) => FlLine(
          color: GlobalsColor.darkGreen,
          strokeWidth: 1
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => TextStyle(color: GlobalsColor.darkGreen, fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            return value.toInt().toString();
          },
          margin: 8
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          margin: 12,
          getTextStyles: (value) => TextStyle(color: GlobalsColor.darkGreen, fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            return "";
          }
        ),
      ),
      minX: data.keys.reduce(min),
      maxX: data.keys.reduce(max),
      minY: data.values.reduce(min),
      maxY: data.values.reduce(max),
      lineBarsData: [
        LineChartBarData(
          spots: data.keys.map((k) => new FlSpot(k, data[k])).toList(),
          belowBarData: BarAreaData(
            show: true
          )
        ),
      ],
    ));
  }
}