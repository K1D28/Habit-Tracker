import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Box habitBox;
  List<Habit> habitList = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  // Load habits from the Hive box
  Future<void> _loadHabits() async {
    habitBox = await Hive.openBox('habits');
    final habits =
        habitBox.values
            .map(
              (e) => Habit.fromMap(Map<String, dynamic>.from(e)),
            ) // Map the data to Habit objects
            .toList();
    setState(() {
      habitList = habits; // Update the state with loaded habits
    });
  }

  // Get days in current month and year
  List<DateTime> getDaysInMonth(DateTime dateTime) {
    final firstDayOfMonth = DateTime(dateTime.year, dateTime.month, 1);
    final lastDayOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);
    List<DateTime> days = [];

    for (
      var i = firstDayOfMonth;
      i.isBefore(lastDayOfMonth.add(Duration(days: 1)));
      i = i.add(Duration(days: 1))
    ) {
      days.add(i);
    }

    return days;
  }

  // Get completed habits for a specific date
  List<Habit> _getCompletedHabitsForDay(DateTime date) {
    return habitList.where((habit) {
      // This is just a placeholder logic for completion. You can use real data to track completion.
      return habit.createdAt.year == date.year &&
          habit.createdAt.month == date.month &&
          habit.createdAt.day == date.day &&
          habit.isCompleted;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final daysInMonth = getDaysInMonth(today);

    return Scaffold(
      appBar: AppBar(title: const Text('Habit Calendar')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DateFormat('MMMM yyyy').format(today),
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleLarge, // Use titleLarge instead of headline5
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: daysInMonth.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // 7 days a week
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                final day = daysInMonth[index];

                // Get the completed habits for this day
                final completedHabits = _getCompletedHabitsForDay(day);

                return Container(
                  decoration: BoxDecoration(
                    color:
                        completedHabits.isNotEmpty
                            ? Colors.teal
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.d().format(day),
                        style: TextStyle(
                          color:
                              completedHabits.isNotEmpty
                                  ? Colors.white
                                  : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (completedHabits.isNotEmpty)
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        ), // Show a checkmark icon if completed
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
