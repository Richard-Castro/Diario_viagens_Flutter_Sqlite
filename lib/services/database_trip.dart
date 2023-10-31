import 'package:agencia_viagens/models/trips_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseTrips {
  final String dbName = 'dbtrips.db';
  final String tableName = 'trips';

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
      version: 3,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trips (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        date TEXT
      )
    ''');
  }

  Future<int> insertTrip(Map<String, dynamic> trip) async {
    final db = await database;
    int? id = trip['id'];
    String date = trip['date']; // Deve estar no formato 'YYYY-MM-DD'

    final existingTrip =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (existingTrip.isNotEmpty) {
      id = null;
    }

    return await db.insert(tableName, {
      'id': id,
      'title': trip['title'],
      'description': trip['description'],
      'date': trip['date'],
    });
  }

  Future<List<Trip>> getAllTrips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, orderBy: 'date DESC');
    return List.generate(maps.length, (index) {
      return Trip.fromMap(maps[index]);
    });
  }
}
