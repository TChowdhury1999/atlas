import 'package:flutter/material.dart';
import 'package:atlas/theme/app_theme.dart';

class MetricSelector extends StatefulWidget {
  const MetricSelector({super.key});

  @override
  State<MetricSelector> createState() => _MetricSelectorState();
}

class _MetricSelectorState extends State<MetricSelector> {

  List<String> selectedMetrics = ["Weight", "Waist", "Bench", "Lat Pull"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children:  selectedMetrics.map((metric) => FilterChip(label: Text(metric), onSelected: (val) {})).toList(),
        )
    );
  }
}