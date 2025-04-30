import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HabitCalendar extends StatelessWidget {
  final Map<DateTime, bool> completionMap;

  const HabitCalendar({super.key, required this.completionMap});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(today.year, today.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(today.year, today.month);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final day = firstDayOfMonth.add(Duration(days: index));
        final completed =
            completionMap[DateTime(day.year, day.month, day.day)] ?? false;

        return Container(
          decoration: BoxDecoration(
            color: completed ? Colors.teal : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            DateFormat.d().format(day),
            style: TextStyle(
              color: completed ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
