import 'package:flutter/material.dart';
import 'package:atlas/theme/app_theme.dart';

class MetricSelector extends StatefulWidget {
  const MetricSelector({super.key});

  @override
  State<MetricSelector> createState() => _MetricSelectorState();
}

class _MetricSelectorState extends State<MetricSelector> {

  List<String> selectedMetrics = ["Weight", "Waist", "Bench", "Lat Pull", "Other"];
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
                val ? activeMetrics.add(metric) : activeMetrics.remove(metric);
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