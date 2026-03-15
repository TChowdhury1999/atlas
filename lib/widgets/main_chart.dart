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
  Map<String, List<FlSpot>> normalisedData = {};
  DateTime? startDate;

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
      startDate ??= DateTime.parse(metricData.first.date);
      loaded[metric] = metricData.map( 
        (e) => FlSpot(DateTime.parse(e.date).difference(startDate!).inDays.toDouble(), e.value)
      ).toList();
    }
    setState(() {
      allData = loaded;
    });
    normalise();
  }

  void normalise() {
    Map<String, List<FlSpot>> hold = {};
    num first_value = 0;
    for (final (i, metric) in widget.activeMetrics.indexed) {
      if (i == 0) {
        first_value = allData[metric]!.first.y;
        hold[metric] = allData[metric]!;
      } else {
        num normalisation_value = allData[metric]!.first.y - first_value;
        hold[metric] = allData[metric]!.map((spot) => FlSpot(spot.x, spot.y - normalisation_value)).toList();
      }
    }
    setState(() {
      normalisedData = hold;
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
    for (final (i, metric) in widget.activeMetrics.indexed) {
      hold.add(
        LineChartBarData(
          spots: normalisedData[metric] ?? [],
          isCurved: true,
          color: AppTheme.lineColors[i],
          barWidth: 2,
          dotData: FlDotData(show: true),
        ),
      );
    }
    return hold;
  }

  @override
  Widget build(BuildContext context) {

    final allSpots = widget.activeMetrics
    .expand((metric) => normalisedData[metric] ?? [])
    .toList();

    if (allData.isEmpty) return const Center(child: CircularProgressIndicator());
      
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 48, 24, 4),
      child: LineChart(
        LineChartData(
          lineBarsData: getLineChartBarData(),
          minX: -5,
          maxX: allSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b) + 30,
          minY: round(allSpots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 1, 0),
          maxY: round(allSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 1, 0),
          gridData: FlGridData(
            show: true,
            verticalInterval: 1,
            checkToShowVerticalLine: (value) {
              final date = startDate!.add(Duration(days: value.toInt()));
              return round(date.day, 0) == 1;
            },
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 35)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final date = startDate!.add(Duration(days: value.toInt()));
                  if (date.day!=15) return const SizedBox.shrink();
                  return Text(month_index_to_str(date.month));
                }
              )
            )
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final metric = widget.activeMetrics.elementAt(spot.barIndex);
                  final rawSpot = allData[metric]?.firstWhere(
                    (s) => s.x == spot.x,
                    orElse: () => spot,
                  );
                  return LineTooltipItem(
                    '${metric}: ${rawSpot?.y}',
                    TextStyle(color: AppTheme.textPrimary)
                  );
                }).toList();
              },
            ),
          )
        ),
      ),
    );
  }
}