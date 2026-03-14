import 'package:flutter/material.dart';
import 'package:atlas/theme/app_theme.dart';
import 'package:atlas/services/data_service.dart';

class MetricSelector extends StatefulWidget {
  const MetricSelector({super.key});

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
      selectedMetrics = metrics.map( (m) => _formatText(m)).toList();
    });
  }

  String _formatText(String text) {
    List<String> parts = text.split(RegExp(r'[ _-]'));
    String formattedText = parts.map(
        (part) => part[0].toUpperCase() + part.substring(1)).join(" ");
    return formattedText;
  }

  Set<String> activeMetrics = {'Weight'};

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
            selected: activeMetrics.contains(metric),
            onSelected: (val) {
              setState(() {
                if (val) {
                  activeMetrics.add(metric);
                } else if (activeMetrics.length > 1) {
                  activeMetrics.remove(metric);
                }
              });
            },
            labelStyle: TextStyle(color: AppTheme.textPrimary),
            selectedColor: AppTheme.surface.withAlpha(204),
            backgroundColor: AppTheme.surface,
            labelPadding: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 6),
            showCheckmark: false,
            side: activeMetrics.contains(metric)
                ? BorderSide(color: AppTheme.accent)
                : BorderSide.none,
            ),
        )).toList(),
      )
    );
  }
}