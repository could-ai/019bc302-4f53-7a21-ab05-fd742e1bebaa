import 'dart:async';
import '../models/models.dart';

class MockDataService {
  // Singleton pattern
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final List<FoodEntry> _entries = [
    FoodEntry(
      id: '1',
      name: 'Oatmeal & Berries',
      calories: 350,
      protein: 12,
      carbs: 60,
      fat: 6,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    FoodEntry(
      id: '2',
      name: 'Grilled Chicken Salad',
      calories: 450,
      protein: 40,
      carbs: 15,
      fat: 20,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  final int _calorieGoal = 2200;
  final int _proteinGoal = 150;
  final int _carbsGoal = 250;
  final int _fatGoal = 70;

  Future<List<FoodEntry>> getRecentEntries() async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network
    return List.from(_entries.reversed);
  }

  Future<DailySummary> getDailySummary() async {
    await Future.delayed(const Duration(milliseconds: 400)); // Simulate network
    int totalCals = 0;
    int totalProtein = 0;
    int totalCarbs = 0;
    int totalFat = 0;

    for (var entry in _entries) {
      totalCals += entry.calories;
      totalProtein += entry.protein;
      totalCarbs += entry.carbs;
      totalFat += entry.fat;
    }

    return DailySummary(
      calorieGoal: _calorieGoal,
      caloriesConsumed: totalCals,
      proteinConsumed: totalProtein,
      carbsConsumed: totalCarbs,
      fatConsumed: totalFat,
      proteinGoal: _proteinGoal,
      carbsGoal: _carbsGoal,
      fatGoal: _fatGoal,
    );
  }

  Future<void> addEntry(FoodEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    _entries.add(entry);
  }
}
