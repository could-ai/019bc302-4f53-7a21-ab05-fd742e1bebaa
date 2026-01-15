class FoodEntry {
  final String id;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final DateTime timestamp;

  FoodEntry({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.timestamp,
  });
}

class DailySummary {
  final int calorieGoal;
  final int caloriesConsumed;
  final int proteinConsumed;
  final int carbsConsumed;
  final int fatConsumed;
  final int proteinGoal;
  final int carbsGoal;
  final int fatGoal;

  DailySummary({
    required this.calorieGoal,
    required this.caloriesConsumed,
    required this.proteinConsumed,
    required this.carbsConsumed,
    required this.fatConsumed,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
  });

  int get caloriesRemaining => calorieGoal - caloriesConsumed;
}
