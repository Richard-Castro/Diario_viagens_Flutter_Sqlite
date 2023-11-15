import 'package:agencia_viagens/models/trips_model.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite_common/sqlite_api.dart';
import 'package:path/path.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
    // sqfliteFfiInit();
    // databaseFactory = databaseFactoryFfi;

    final path = join(await getDatabasesPath(), dbName);
    return openDatabase(
      path,
      version: 7,
      onCreate: _createDatabase,
      //onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trips (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        date TEXT,
        startDate TEXT,
        endDate TEXT,
        imagePath TEXT
        
      )
    ''');
  }

  // Future<void> _upgradeDatabase(
  //     Database db, int oldVersion, int newVersion) async {
  //   if (newVersion > oldVersion) {
  //     await db.execute('ALTER TABLE trips ADD COLUMN imagePath TEXT');
  //     //await db.execute('ALTER TABLE trips ADD COLUMN endDate TEXT');
  //   }
  // }

  Future<int> insertTrip(Map<String, dynamic> trip) async {
    final db = await database;
    int? id = trip['id'];

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
      'startDate': trip['startDate'],
      'endDate': trip['endDate'],
      'imagePath': trip['imagePath'],
    });
  }

  Future<List<Trip>> getAllTrips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, orderBy: 'id DESC');
    return List.generate(maps.length, (index) {
      return Trip.fromMap(maps[index]);
    });
  }
}
