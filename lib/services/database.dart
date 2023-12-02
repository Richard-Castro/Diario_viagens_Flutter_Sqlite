import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/trips_model.dart';
import '../models/details_model.dart';

class DatabasesTrips {
  final String dbName = 'database.db';
  final String tripsTableName = 'trips';
  final String detailsTableName = 'details';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDatabase();
      return _database!;
    }
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), dbName);

    return openDatabase(
      path,
      version: 2,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tripsTableName (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        date TEXT,
        startDate TEXT,
        endDate TEXT,
        imagePath TEXT
        
      )
    ''');

    await db.execute('''
      CREATE TABLE $detailsTableName (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        date TEXT,
        startDate TEXT,
        endDate TEXT,
        imagePath TEXT,
        tripId INTEGER,
        FOREIGN KEY (tripId) REFERENCES $tripsTableName(id)
      );
    ''');
  }

  Future<int> insertTrips(Map<String, dynamic> trip) async {
    final db = await database;
    int? id = trip['id'];

    final existingTrip =
        await db.query(tripsTableName, where: 'id = ?', whereArgs: [id]);
    if (existingTrip.isNotEmpty) {
      id = null;
    }

    return await db.insert(tripsTableName, {
      'id': id,
      'title': trip['title'],
      'description': trip['description'],
      'date': trip['date'],
      'startDate': trip['startDate'],
      'endDate': trip['endDate'],
      'imagePath': trip['imagePath'],
    });
  }

  Future<int> insertDetails(Map<String, dynamic> details) async {
    final db = await database;
    int? id = details['id'];

    final existingDetails =
        await db.query(detailsTableName, where: 'id = ?', whereArgs: [id]);
    if (existingDetails.isNotEmpty) {
      id = null;
    }

    return await db.insert(detailsTableName, {
      'id': id,
      'tripId': details['tripId'],
      'title': details['title'],
      'description': details['description'],
      'date': details['date'],
      'startDate': details['startDate'],
      'endDate': details['endDate'],
      'imagePath': details['imagePath'],
    });
  }

  // Future<int> insertTrips(Map<String, dynamic> trips) async {
  //   final db = await database;
  //   int id = trips['id'];

  //   final existingTrips =
  //       await db.query(tripsTableName, where: 'id = ?', whereArgs: [id]);

  //   if (existingTrips.isEmpty) {
  //     return await db.insert(tripsTableName, trips);
  //   } else {
  //     return await db.update(
  //       tripsTableName,
  //       trips,
  //       where: 'id = ?',
  //       whereArgs: [id],
  //     );
  //   }
  // }

  // Future<int> insertDetails(Map<String, dynamic> details) async {
  //   final db = await database;
  //   int id = details['id'];

  //   final existingDetails =
  //       await db.query(detailsTableName, where: 'id = ?', whereArgs: [id]);

  //   if (existingDetails.isEmpty) {
  //     return await db.insert(detailsTableName, details);
  //   } else {
  //     return await db.update(
  //       detailsTableName,
  //       details,
  //       where: 'id = ?',
  //       whereArgs: [id],
  //     );
  //   }
  // }

  Future<List<Trips>> getAllTrips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(tripsTableName, orderBy: 'id DESC');
    return List.generate(maps.length, (index) {
      return Trips.fromMap(maps[index]);
    });
  }

  Future<List<Details>> getAllDetails() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(detailsTableName, orderBy: 'id DESC');
    return List.generate(maps.length, (index) {
      return Details.fromMap(maps[index]);
    });
  }

  Future<int> updateTrips(Map<String, dynamic> trip) async {
    final db = await database;
    int? id = trip['id'] ?? 0;

    return await db.update(
      tripsTableName,
      trip,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTrips(int? id) async {
    final db = await database;
    return await db.delete(tripsTableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteDetails(int? id) async {
    final db = await database;
    return await db.delete(detailsTableName, where: 'id = ?', whereArgs: [id]);
  }
}
