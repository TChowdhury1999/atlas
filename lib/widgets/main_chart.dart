import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:atlas/theme/app_theme.dart';
import 'package:atlas/models/data_entry.dart';
import 'package:atlas/services/data_service.dart';

class MainChart extends StatefulWidget {
  const MainChart({super.key});

  @override
  State<MainChart> createState() => _MainChartState();  
}

class _MainChartState extends State<MainChart> {

  List<DataEntry> weightEntries = [];
  

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final entries = await DataService().loadData();
    setState(() {
      weightEntries = entries;
    });
  }

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

    if (weightEntries.isEmpty) return const Center(child: CircularProgressIndicator());

    final startDate = DateTime.parse(weightEntries.first.date);
    final List<FlSpot> weightSpots = weightEntries.map(
        (e) => FlSpot(DateTime.parse(e.date).difference(startDate).inDays.toDouble(), e.value)
      ).toList();
      
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

