import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import '../widgets/habit_tile.dart';
import '../widgets/empty_state.dart';
import '../services/local_storage_service.dart'; // Make sure this is imported

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box habitBox;
  List<Habit> habitList = [];

  @override
  void initState() {
    super.initState();
    _loadHabits(); // Initial load of habits when screen is loaded
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

  // Function to add a habit to the list and save it in Hive
  Future<void> _addHabit(Habit newHabit) async {
    await habitBox.put(newHabit.id, newHabit.toMap()); // Save new habit to Hive
    setState(() {
      habitList.add(newHabit); // Immediately add the new habit to the list
    });
  }

  // Toggle the completion status of a habit
  void _toggleCompletion(Habit habit) async {
    setState(() {
      habit.isCompleted = !habit.isCompleted; // Toggle the completion status
    });

    await habitBox.put(habit.id, habit.toMap()); // Update habit in Hive
  }

  // Delete a habit from Hive
  void _deleteHabit(Habit habit) async {
    await habitBox.delete(habit.id); // Delete the habit from Hive
    setState(() {
      habitList.remove(habit); // Remove the habit from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitHive'),
        actions: [
          // Profile icon to navigate to ProfileScreen
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/profile',
              ); // Navigate to Profile Screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => Navigator.pushNamed(context, '/calendar'),
          ),
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () => Navigator.pushNamed(context, '/streak'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body:
          habitList.isEmpty
              ? const EmptyState() // Show empty state if no habits exist
              : ListView.builder(
                itemCount: habitList.length, // Number of habits to display
                itemBuilder: (context, index) {
                  final habit = habitList[index];
                  return HabitTile(
                    title: habit.name,
                    icon: habit.icon,
                    isCompleted:
                        habit.isCompleted, // Use the dynamic completion state
                    onToggle:
                        () => _toggleCompletion(
                          habit,
                        ), // Toggle completion on tap
                    onDelete:
                        () => _deleteHabit(
                          habit,
                        ), // Delete habit when icon is clicked
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddEditHabitScreen and wait for the new habit
          final newHabit = await Navigator.pushNamed(context, '/add') as Habit?;

          // If a new habit was returned, add it to the list and refresh UI
          if (newHabit != null) {
            _addHabit(newHabit); // Add new habit dynamically without restarting
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
