import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'storage/hive_boxes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await HiveBoxes.initHive(); // Open all necessary boxes

  runApp(const HabitHiveApp());
}
