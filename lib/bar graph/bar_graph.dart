import 'package:expense_tracker/bar%20graph/individual_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  final List<double> monthlySummary; // [25, 500, 120..]
  final int startMonth; // 0 JAN, 1 FEB, 2 MAR ..

  const MyBarGraph({
    super.key,
    required this.monthlySummary,
    required this.startMonth,
  });

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  // TODO this list will hold the data for each bar
  List<IndividualBar> barData = [];

  // TODO initialize bar data - user our monthly summary to create a list of bars
  void initializeBarData(){
    barData = List.generate(
        widget.monthlySummary.length,
        (index) => IndividualBar(
          x: index,
          y: widget.monthlySummary[index],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 100,
      )
    );
  }
}
