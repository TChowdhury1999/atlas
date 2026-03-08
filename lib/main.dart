import 'package:flutter/material.dart';
import 'package:atlas/theme/app_theme.dart';
import 'package:atlas/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atlas',
      theme: AppTheme.darkTheme,
      home: HomeScreen(),
    );
  }
}