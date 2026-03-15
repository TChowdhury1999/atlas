import 'package:flutter/material.dart';
import 'package:atlas/theme/app_theme.dart';
import 'package:atlas/widgets/main_chart.dart';
import 'package:atlas/widgets/metric_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Set<String> activeMetrics = {'Weight'};

  void _onMetricToggled(String metric, bool val) {
    setState(() {
      final updated = Set<String>.from(activeMetrics);
      if (val) {
        updated.add(metric);
      } else if (activeMetrics.length > 1) {
        updated.remove(metric);
      }
      activeMetrics = updated;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: MainChart(activeMetrics: activeMetrics)),
          MetricSelector(activeMetrics: activeMetrics, onMetricToggled: _onMetricToggled),
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppTheme.surface,
        selectedItemColor: AppTheme.accent,
        unselectedItemColor: AppTheme.textSecondary,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Metrics'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40), label: 'Log'),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Import'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),          
        ],
      ),
    );
  }
}
