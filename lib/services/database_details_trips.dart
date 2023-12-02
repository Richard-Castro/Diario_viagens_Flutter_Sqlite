// import 'package:agencia_viagens/models/register_trips_model.dart';
// import 'package:agencia_viagens/services/database_trip.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseDetailTrips {
//   final String dbName = 'dbtrips.db';
//   final String detailsTripsTableName = 'detailsTrips';

//   Database? _database;

//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     } else {
//       _database = await initDatabase();
//       return _database!;
//     }
//   }

//   Future<Database> initDatabase() async {
//     final path = join(await getDatabasesPath(), dbName);
//     return openDatabase(
//       path,
//       version: 2, // Aumente o número da versão conforme necessário
//       onCreate: _createDatabase,
//       // onConfigure: (db) async {
//       //   await db.execute('PRAGMA foreign_keys = ON');
//       // },
//     );
//   }

//   Future<void> _createDatabase(Database db, int version) async {
//     try {
//       print('Iniciando a criação da tabela $detailsTripsTableName...');
//       await db.execute('''
//       CREATE TABLE detailsTrips (
//         id INTEGER PRIMARY KEY,
//         title TEXT,
//         description TEXT,
//         date TEXT,
//         startDate TEXT,
//         endDate TEXT,
//         imagePath TEXT,
//         tripId INTEGER,
//         FOREIGN KEY (tripId) REFERENCES trips(id)
//       );
//     ''');
//       print('Tabela $detailsTripsTableName criada com sucesso!');
//     } catch (e) {
//       print('Erro durante a criação da tabela $detailsTripsTableName: $e');
//       // Adicione a lógica de tratamento de erro conforme necessário
//       throw e;
//     }
//   }

//   Future<void> checkTableExists() async {
//     final db = await database;
//     final tables = await db.rawQuery(
//       "SELECT name FROM sqlite_master WHERE type='table' AND name=?;",
//       [detailsTripsTableName],
//     );
//     print('Tabela $detailsTripsTableName existe: ${tables.isNotEmpty}');
//   }

//   Future<int> insertTrip(Map<String, dynamic> detailsTrips) async {
//     final db = await database;
//     int id = detailsTrips['id'];

//     final existingTrip = await db.query(
//       detailsTripsTableName,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (existingTrip.isEmpty) {
//       return await db.insert(detailsTripsTableName, detailsTrips);
//     } else {
//       detailsTrips.remove('tripId');
//       return await db.update(
//         detailsTripsTableName,
//         detailsTrips,
//         where: 'id = ?',
//         whereArgs: [id],
//       );
//     }
//   }

//   Future<List<Details>> getAllTrips() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps =
//         await db.query(detailsTripsTableName, orderBy: 'id DESC');
//     return List.generate(maps.length, (index) {
//       return Details.fromMap(maps[index]);
//     });
//   }

//   Future<int> deleteTrip(int? id) async {
//     final db = await database;
//     return await db
//         .delete(detailsTripsTableName, where: 'id = ?', whereArgs: [id]);
//   }
// }
