class Habit {
  final String id;
  final String name;
  final String icon;
  final DateTime createdAt;
  bool isCompleted; // Add this field

  Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.createdAt,
    this.isCompleted = false, // Default to false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted, // Save completion state
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      createdAt: DateTime.parse(map['createdAt']),
      isCompleted:
          map['isCompleted'] ?? false, // Default to false if not present
    );
  }
}
