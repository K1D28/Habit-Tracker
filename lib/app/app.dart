import 'package:flutter/material.dart';
import '../screens/home_screen.dart'; // Home screen for the app
import '../screens/add_edit_habit_screen.dart'; // Screen for adding/editing habits
import '../screens/calendar_screen.dart'; // Calendar screen for habit tracking
import '../screens/streak_screen.dart'; // Streak screen to show progress
import '../screens/settings_screen.dart'; // Settings screen
import '../screens/profile_screen.dart'; // Profile screen
import '../screens/profile_settings_screen.dart'; // Profile settings screen

class HabitHiveApp extends StatelessWidget {
  const HabitHiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitHive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/', // Home screen as the initial screen
      routes: {
        '/': (context) => const HomeScreen(), // Home Screen route
        '/add':
            (context) =>
                const AddEditHabitScreen(), // Add/Edit Habit Screen route
        '/calendar':
            (context) => const CalendarScreen(), // Calendar Screen route
        '/streak': (context) => const StreakScreen(), // Streak Screen route
        '/settings':
            (context) => const SettingsScreen(), // Settings Screen route
        '/profile': (context) => const ProfileScreen(), // Profile Screen route
        '/profile-settings':
            (context) =>
                const ProfileSettingsScreen(), // Profile Settings route
      },
    );
  }
}
