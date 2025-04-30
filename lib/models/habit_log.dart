class HabitLog {
  final String habitId;
  final DateTime date;
  final bool isCompleted;

  HabitLog({
    required this.habitId,
    required this.date,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory HabitLog.fromMap(Map<String, dynamic> map) {
    return HabitLog(
      habitId: map['habitId'],
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'],
    );
  }
}
