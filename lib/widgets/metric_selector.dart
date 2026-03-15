import 'package:flutter/material.dart';
import 'package:atlas/theme/app_theme.dart';
import 'package:atlas/services/data_service.dart';
import 'package:atlas/utils/utils.dart';

class MetricSelector extends StatefulWidget {
  final Set<String> activeMetrics;
  final Function(String, bool) onMetricToggled;

  const MetricSelector({
    super.key,
    required this.activeMetrics,
    required this.onMetricToggled,
  });

  @override
  State<MetricSelector> createState() => _MetricSelectorState();
}

class _MetricSelectorState extends State<MetricSelector> {

  List<String> availableMetrics = [];
  List<String> selectedMetrics = [];
  //["Weight", "Waist", "Bench", "Lat Pull", "Other"];

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics () async {
    final metrics = await DataService().loadAvailableMetrics();
    setState(() {
      availableMetrics = metrics;
      selectedMetrics = metrics.map( (m) => formatText(m)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children:  selectedMetrics.map((metric) => Expanded(
          child: FilterChip(
            label: Text(
              metric,
              style: TextStyle(fontSize: 12),
              ),
            selected: widget.activeMetrics.contains(metric),
            onSelected: (val) {
              widget.onMetricToggled(metric, val);
            },
            labelStyle: TextStyle(color: AppTheme.textPrimary),
            selectedColor: AppTheme.surface.withAlpha(204),
            backgroundColor: AppTheme.surface,
            labelPadding: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 6),
            showCheckmark: false,
            side: widget.activeMetrics.contains(metric)
                ? BorderSide(color: AppTheme.accent)
                : BorderSide.none,
            ),
        )).toList(),
      )
    );
  }
}