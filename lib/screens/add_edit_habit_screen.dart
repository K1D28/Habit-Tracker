import 'package:flutter/material.dart';
import '../data/habit_icon_list.dart';
import '../models/habit.dart';
import '../services/local_storage_service.dart';
import '../utils/helpers.dart'; // For generateUniqueId()

class AddEditHabitScreen extends StatefulWidget {
  const AddEditHabitScreen({super.key});

  @override
  State<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends State<AddEditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _habitNameController = TextEditingController();

  String selectedIcon = habitIcons.first;

  void _openIconPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: habitIcons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final icon = habitIcons[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIcon = icon;
                });
                Navigator.pop(context);
              },
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 28)),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveHabit() async {
    final habit = Habit(
      id: generateUniqueId(),
      name: _habitNameController.text.trim(),
      icon: selectedIcon,
      createdAt: DateTime.now(),
    );

    await LocalStorageService.addHabit(habit);

    // Pop the screen and return the newly created habit to the previous screen (HomeScreen)
    Navigator.pop(context, habit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Habit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _habitNameController,
                decoration: const InputDecoration(labelText: 'Habit Name'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Choose Icon: '),
                  TextButton(
                    onPressed: _openIconPicker,
                    child: Text(
                      selectedIcon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveHabit();
                  }
                },
                child: const Text('Save Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
