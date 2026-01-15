import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MacroIndicator extends StatelessWidget {
  final String label;
  final int value;
  final int goal;
  final Color color;

  const MacroIndicator({
    super.key,
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (value / goal).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              '${value}g / ${goal}g',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surfaceHighlight,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 6,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
