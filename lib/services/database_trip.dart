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
    return openDatabase(path, version: 2, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trips (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
       
      )
    ''');
  }

  /*Future<void> _upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      await db.execute('ALTER TABLE trips ADD COLUMN date TEXT');
    }
  }*/

  Future<int> insertTrip(Map<String, dynamic> trip) async {
    final db = await database;
    int? id = trip['id'];

    // Verificar se o ID já existe
    final existingTrip =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (existingTrip.isNotEmpty) {
      // O ID já existe, gerar um novo ID exclusivo
      id = null;
    }

    // Inserir o registro com o ID (ou um novo ID gerado automaticamente)
    return await db.insert(tableName, {
      'id': id, // Pode ser null para gerar um ID automático
      'title': trip['title'],
      'description': trip['description'],
    });
  }

  Future<List<Trip>> getAllTrips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return Trip.fromMap(maps[index]);
    });
  }
}
