import 'package:flutter/material.dart';

class StreakCounter extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;

  const StreakCounter({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          '🔥 Current Streak: $currentStreak days',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '🏆 Best Streak: $bestStreak days',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
