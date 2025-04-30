import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'profile_settings_screen.dart'; // Import ProfileScreen

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Function to clear all data from Hive
  Future<void> _clearAllData(BuildContext context) async {
    final habitBox = await Hive.openBox('habits'); // Open the habits box
    final logBox = await Hive.openBox('habit_logs'); // Open the habit logs box

    // Clear both boxes
    await habitBox.clear();
    await logBox.clear();

    // After clearing, show a success message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All data has been cleared!')));

    // Optionally, pop the settings screen to return to HomeScreen or reset state
    Navigator.pop(context); // Navigate back to the previous screen (HomeScreen)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile Settings'),
            onTap: () {
              // Navigate to the profile screen where users can update their profile
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileSettingsScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Clear All Data'),
            onTap: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Confirm Clear'),
                      content: const Text(
                        'Are you sure you want to delete all habits and data?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            _clearAllData(context); // Call to delete all data
                            Navigator.pop(
                              context,
                            ); // Close dialog after confirmation
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'HabitHive v1.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
