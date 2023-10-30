// ignore_for_file: prefer_const_declarations, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'my_app.dart';
import 'services/database_trip.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  final databaseTrips = DatabaseTrips();
  await databaseTrips.initDatabase();

  runApp(const MyApp());
}
