import '../models/habit.dart';

final dummyHabits = [
  Habit(
    id: 'h1',
    name: 'Drink Water',
    icon: '💧',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Habit(
    id: 'h2',
    name: 'Exercise',
    icon: '🏃‍♂️',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];
