import '../models/habit_log.dart';

class HabitUtils {
  static int calculateCurrentStreak(List<HabitLog> logs) {
    logs.sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime today = DateTime.now();
    for (int i = 0; i < logs.length; i++) {
      final log = logs[i];
      final expectedDate = today.subtract(Duration(days: streak));

      if (_isSameDate(log.date, expectedDate) && log.isCompleted) {
        streak++;
      } else if (log.date.isBefore(expectedDate)) {
        break;
      }
    }
    return streak;
  }

  static int calculateBestStreak(List<HabitLog> logs) {
    logs.sort((a, b) => a.date.compareTo(b.date));
    int best = 0;
    int current = 0;
    DateTime? lastDate;

    for (final log in logs) {
      if (!log.isCompleted) continue;

      if (lastDate == null || log.date.difference(lastDate).inDays == 1) {
        current++;
      } else if (log.date.difference(lastDate!).inDays > 1) {
        current = 1;
      }
      lastDate = log.date;
      best = current > best ? current : best;
    }

    return best;
  }

  static bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
