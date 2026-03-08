import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:atlas/theme/app_theme.dart';

class MainChart extends StatefulWidget {
  const MainChart({super.key});

  @override
  State<MainChart> createState() => _MainChartState();  
}

class _MainChartState extends State<MainChart> {

  final List<FlSpot> weightSpots = [
    FlSpot(0, 68.4),
    FlSpot(1, 68.1),
    FlSpot(2, 68.2),
    FlSpot(3, 67.7),
    FlSpot(4, 67.9),
    FlSpot(5, 67.6),
    FlSpot(6, 67.5),
    FlSpot(7, 67.4),
    FlSpot(8, 67.2),
    FlSpot(9, 67.2),
    FlSpot(10, 67.0),
    FlSpot(11, 67.1),
    FlSpot(12, 66.5),
    FlSpot(13, 66.7),
    FlSpot(14, 66.7),
    FlSpot(15, 66.6),
    FlSpot(16, 66.4),
    FlSpot(17, 66.5),
    FlSpot(18, 66.4),
    FlSpot(19, 66.2),
  ];

  List<FlSpot> getRollingAvg(List<FlSpot> spots, {int window = 7}) {
    List<FlSpot> result = [];
    for (int i = 0; i < spots.length; i++) {
      if (i < window) {
        result.add(FlSpot(i.toDouble(), spots.sublist(0, i+1).fold(0.0, (sum, spot) => sum + spot.y) / (i+1))) ;
      } else {
        result.add(FlSpot(i.toDouble(), spots.sublist(i+1-window, i+1).fold(0.0, (sum, spot) => sum + spot.y) / window ));
      } 
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: weightSpots,
              isCurved: true,
              color: AppTheme.accent,
              barWidth: 2,
              dotData: FlDotData(show: true),
            ),
            LineChartBarData(
              spots: getRollingAvg(weightSpots, window: 7),
              isCurved: true,
              color: AppTheme.primary,
              barWidth: 3,
              dotData: FlDotData(show: false),
            )
          ],
        ),
      ),
    );
  }
}

