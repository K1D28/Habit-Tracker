import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String title;
  final String icon;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onDelete; // Add a callback for delete

  const HabitTile({
    super.key,
    required this.title,
    required this.icon,
    required this.isCompleted,
    required this.onToggle,
    required this.onDelete, // Initialize the delete callback
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 24)),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: isCompleted,
              onChanged: (_) => onToggle(), // Trigger toggle when checked
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete, // Trigger delete when clicked
            ),
          ],
        ),
      ),
    );
  }
}
