import 'package:hive/hive.dart';

class HiveBoxes {
  static const String habitBoxName = 'habits';
  static const String logBoxName = 'habit_logs';

  static Future<void> initHive() async {
    await Hive.openBox(habitBoxName);
    await Hive.openBox(logBoxName);
  }
}
