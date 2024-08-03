// main.dart
import 'package:fashion_app_admin/consts/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';

class AnalysisApp extends StatefulWidget {
  AnalysisApp({Key? key}) : super(key: key);

  @override
  State<AnalysisApp> createState() => _AnalysisAppState();
}

class _AnalysisAppState extends State<AnalysisApp> {
  final List<DataItem> _myData = List.generate(
      30,
          (index) => DataItem(
        x: index,
        y1: Random().nextInt(20) + Random().nextDouble(),
        y2: Random().nextInt(20) + Random().nextDouble(),
        y3: Random().nextInt(20) + Random().nextDouble(),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 300,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: BarChart(BarChartData(
              borderData: FlBorderData(
                  border: const Border(
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide(width: 1),
                    bottom: BorderSide(width: 1),
                  )),
              groupsSpace: 10,
              barGroups: [
                BarChartGroupData(x: 1, barRods: [
                  BarChartRodData(fromY: 0, toY: 10, width: 15, color: AppColor.primaryColor),
                ]),
                BarChartGroupData(x: 2, barRods: [
                  BarChartRodData(fromY: 0, toY: 10, width: 15, color: AppColor.primaryColor),
                ]),
              ])),
        ),
      ),
    );
  }
}

// Define data structure for a bar group
class DataItem {
  int x;
  double y1;
  double y2;
  double y3;
  DataItem(
      {required this.x, required this.y1, required this.y2, required this.y3});
}
