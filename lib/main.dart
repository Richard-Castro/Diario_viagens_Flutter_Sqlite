// ignore_for_file: prefer_const_declarations, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'my_app.dart';
import 'services/database_trip.dart';
import 'package:sqflite_common/sqlite_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseTrips = DatabaseTrips();
  await databaseTrips.initDatabase();

  runApp(const MyApp());
}
