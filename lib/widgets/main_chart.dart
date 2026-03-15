import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:atlas/theme/app_theme.dart';
import 'package:atlas/models/data_entry.dart';
import 'package:atlas/services/data_service.dart';
import 'dart:math';
import 'package:atlas/utils/utils.dart';

class MainChart extends StatefulWidget {
  final Set<String> activeMetrics;
  const MainChart({
    super.key,
    required this.activeMetrics,
  });

  @override
  State<MainChart> createState() => _MainChartState();  
}

class _MainChartState extends State<MainChart> {

  Map<String, List<FlSpot>> allData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(MainChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeMetrics != widget.activeMetrics) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    Map<String,  List<FlSpot>> loaded = {};
    for (final metric in widget.activeMetrics) {
      final metricData = await DataService().loadData(metric.toLowerCase());
      final startDate = DateTime.parse(metricData.first.date);
      loaded[metric] = metricData.map( 
        (e) => FlSpot(DateTime.parse(e.date).difference(startDate).inDays.toDouble(), e.value)
      ).toList();
    }
    setState(() {
      allData = loaded;
    });
  }

  List<FlSpot> getRollingAvg(List<FlSpot> spots, {int window = 7}) {
    List<FlSpot> result = [];
    for (int i = 0; i < spots.length; i++) {
      final filtered = spots.where((spot) => spot.x >= spots[i].x - window && spot.x <= spots[i].x).toList();

      result.add(
        FlSpot(
          spots[i].x,
          round(filtered.fold(0.0, (sum, spot) => sum + spot.y) / filtered.length, 2)
          )
        );
    }
    return result;
  }

  List<LineChartBarData> getLineChartBarData() {
    List<LineChartBarData> hold = [];
    for (final metric in widget.activeMetrics) {
      hold.add(
        LineChartBarData(
          spots: allData[metric] ?? [],
          isCurved: true,
          color: AppTheme.accent,
          barWidth: 2,
          dotData: FlDotData(show: true),
        )
      );
    }
    return hold;
  }

  @override
  Widget build(BuildContext context) {

    final allSpots = widget.activeMetrics
    .expand((metric) => allData[metric] ?? [])
    .toList();

    if (allData.isEmpty) return const Center(child: CircularProgressIndicator());
      
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          lineBarsData: getLineChartBarData(),
          minX: 0,
          maxX: allSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b) + 14,
          minY: round(allSpots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 1, 0),
          maxY: round(allSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 1, 0),
        ),
      ),
    );
  }
}

