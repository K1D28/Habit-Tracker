import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import 'package:intl/intl.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  late Box habitBox;
  List<Habit> habitList = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  // Load habits from Hive box
  Future<void> _loadHabits() async {
    habitBox = await Hive.openBox('habits');
    final habits =
        habitBox.values
            .map((e) => Habit.fromMap(Map<String, dynamic>.from(e)))
            .toList();
    setState(() {
      habitList = habits; // Update habitList state
    });
  }

  // Function to calculate the streak for a habit
  int _calculateStreak(Habit habit) {
    int streak = 0;
    DateTime currentDate = DateTime.now();

    // Check completion status and calculate streak
    DateTime? lastCompletedDate =
        habit.createdAt; // Last date habit was completed
    if (habit.isCompleted) {
      // Calculate streak if habit was completed today
      while (lastCompletedDate != null &&
          currentDate.difference(lastCompletedDate).inDays == 1) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Streak Tracker')),
      body:
          habitList.isEmpty
              ? const Center(child: Text('No habits to display.'))
              : ListView.builder(
                itemCount: habitList.length,
                itemBuilder: (context, index) {
                  final habit = habitList[index];
                  int streak = _calculateStreak(habit);

                  return ListTile(
                    title: Text(habit.name),
                    subtitle: Text('Streak: $streak days'),
                    trailing: Text(
                      'Last completed: ${DateFormat('yyyy-MM-dd').format(habit.createdAt)}',
                    ),
                  );
                },
              ),
    );
  }
}
