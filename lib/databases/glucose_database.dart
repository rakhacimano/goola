import 'package:goola/models/glucose.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GlucoseDatabase {

  static final GlucoseDatabase instance = GlucoseDatabase._init();

  GlucoseDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('glucose.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const sql = '''
    CREATE TABLE $tableGlucose(
      ${GlucoseFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${GlucoseFields.amount} TEXT NOT NULL,
      ${GlucoseFields.time} TEXT NOT NULL
    )
    ''';
    await db.execute(sql);
  }

  Future<Glucose> create(Glucose glucose) async {
    final db = await instance.database;
    final id = await db.insert(tableGlucose, glucose.toJson());
    return glucose.copy(id: id);
  }

  Future<List<Glucose>> getAllGlucoses() async {
    final db = await instance.database;
    final result = await db.query(tableGlucose);
    return result.map((json) => Glucose.fromJson(json)).toList();
  }

  Future<Glucose> getGlucoseById(int id) async {
    final db = await instance.database;
    final result = await db.query(tableGlucose,
        where: '${GlucoseFields.id} = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Glucose.fromJson(result.first);
    } else {
      throw Exception('ID $id not found ');
    }
  }

  Future<int> deleteGlucoseById(int id) async {
    final db = await instance.database;
    return await db.delete(tableGlucose, 
      where: '${GlucoseFields.id} = ?', whereArgs: [id]
    );
  }

  Future<int> updateGlucose(Glucose glucose) async {
    final db = await instance.database;
    return await db.update(tableGlucose, glucose.toJson(),
      where: '${GlucoseFields.id} = ?', whereArgs: [glucose.id]
    );
  }
}