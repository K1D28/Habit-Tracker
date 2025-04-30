import 'package:hive/hive.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';

class LocalStorageService {
  static const String habitBoxName = 'habits';
  static const String logBoxName = 'habit_logs';

  static Future<void> init() async {
    await Hive.openBox(habitBoxName);
    await Hive.openBox(logBoxName);
  }

  // HABIT CRUD
  static Future<void> addHabit(Habit habit) async {
    final box = Hive.box(habitBoxName);
    await box.put(habit.id, habit.toMap());
  }

  static List<Habit> getAllHabits() {
    final box = Hive.box(habitBoxName);
    return box.values
        .map((e) => Habit.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> deleteHabit(String id) async {
    final box = Hive.box(habitBoxName);
    await box.delete(id);
  }

  // HABIT LOG CRUD
  static Future<void> logHabitCompletion(HabitLog log) async {
    final box = Hive.box(logBoxName);
    final key = '${log.habitId}_${log.date.toIso8601String().split("T")[0]}';
    await box.put(key, log.toMap());
  }

  static List<HabitLog> getHabitLogs(String habitId) {
    final box = Hive.box(logBoxName);
    return box.values
        .map((e) => HabitLog.fromMap(Map<String, dynamic>.from(e)))
        .where((log) => log.habitId == habitId)
        .toList();
  }

  static Future<void> clearAllData() async {
    await Hive.box(habitBoxName).clear();
    await Hive.box(logBoxName).clear();
  }
}
