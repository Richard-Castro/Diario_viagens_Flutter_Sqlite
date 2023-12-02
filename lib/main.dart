import '../services/database.dart';
import 'package:flutter/material.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databasesTrips = DatabasesTrips();
  await databasesTrips.initDatabase();

  runApp(const MyApp());
}
