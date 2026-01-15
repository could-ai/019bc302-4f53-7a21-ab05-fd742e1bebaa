import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_entry_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CouldAI Calorie Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/add': (context) => const AddEntryScreen(),
      },
    );
  }
}
