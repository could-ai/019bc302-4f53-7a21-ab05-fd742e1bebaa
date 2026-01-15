import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../widgets/tech_card.dart';
import '../widgets/macro_indicator.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DailySummary> _summaryFuture;
  late Future<List<FoodEntry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _summaryFuture = MockDataService().getDailySummary();
      _entriesFuture = MockDataService().getRecentEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COULDAI TRACKER'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        color: AppTheme.primary,
        backgroundColor: AppTheme.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummarySection(),
              const SizedBox(height: 24),
              _buildRecentEntriesSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add');
          if (result == true) {
            _refreshData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection() {
    return FutureBuilder<DailySummary>(
      future: _summaryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const TechCard(child: Text('Error loading summary'));
        }

        final data = snapshot.data!;
        
        return Column(
          children: [
            TechCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildCalorieRing(data),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatItem('EATEN', '${data.caloriesConsumed}', 'kcal'),
                            const SizedBox(height: 16),
                            _buildStatItem('GOAL', '${data.calorieGoal}', 'kcal'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: AppTheme.surfaceHighlight),
                  const SizedBox(height: 16),
                  MacroIndicator(
                    label: 'PROTEIN',
                    value: data.proteinConsumed,
                    goal: data.proteinGoal,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(height: 12),
                  MacroIndicator(
                    label: 'CARBS',
                    value: data.carbsConsumed,
                    goal: data.carbsGoal,
                    color: AppTheme.secondary,
                  ),
                  const SizedBox(height: 12),
                  MacroIndicator(
                    label: 'FAT',
                    value: data.fatConsumed,
                    goal: data.fatGoal,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalorieRing(DailySummary data) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: CalorieRingPainter(
                progress: (data.caloriesConsumed / data.calorieGoal).clamp(0.0, 1.0),
                color: AppTheme.primary,
                backgroundColor: AppTheme.surfaceHighlight,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${data.caloriesRemaining}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Text(
                'REMAINING',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.5,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentEntriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'RECENT ENTRIES',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        FutureBuilder<List<FoodEntry>>(
          future: _entriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const TechCard(
                child: Center(
                  child: Text(
                    'No entries today',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = snapshot.data![index];
                return TechCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceHighlight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${entry.calories} kcal • P: ${entry.protein}g C: ${entry.carbs}g F: ${entry.fat}g',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatTime(entry.timestamp),
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class CalorieRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  CalorieRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    const strokeWidth = 12.0;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2); // Subtle glow

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    // Start from top (-pi/2)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CalorieRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
