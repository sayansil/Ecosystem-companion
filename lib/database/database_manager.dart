import 'package:ecosystem/database/tableSchema/ecosystem_master.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MasterDatabase {
  static final MasterDatabase instance = MasterDatabase._init();

  static Database? _database;

  MasterDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'NUMBER PRIMARY NOT NULL';
    final blobType = 'LONGBLOB NOT NULL';

    await db.execute('''
      CREATE TABLE $masterTable ( 
        ${WorldInstanceFields.year} $idType, 
        ${WorldInstanceFields.avgWorld} $blobType,
        ${WorldInstanceFields.populationWorld} $blobType
      )
      '''
    );
  }

  Future<void> create(WorldInstance worldInstance) async {
    final db = await instance.database;
    await db.insert(masterTable, worldInstance.toMap());
  }

  Future<WorldInstance> read(int year) async {
    final db = await instance.database;

    final maps = await db.query(
      masterTable,
      columns: WorldInstanceFields.values,
      where: '${WorldInstanceFields.year} = ?',
      whereArgs: [year],
    );

    if (maps.isNotEmpty) {
      return WorldInstance.fromMap(maps.first);
    } else {
      throw Exception('Year $year not found');
    }
  }

  Future<List<WorldInstance>> readAllRows() async {
    final db = await instance.database;

    final orderBy = '${WorldInstanceFields.year} ASC';

    final result = await db.query(masterTable, orderBy: orderBy);
    return result.map((rowData) => WorldInstance.fromMap(rowData)).toList();
  }

  Future<int> update(WorldInstance worldInstance) async {
    final db = await instance.database;

    return db.update(
      masterTable,
      worldInstance.toMap(),
      where: '${WorldInstanceFields.year} = ?',
      whereArgs: [worldInstance.year],
    );
  }

  Future<int> delete(int year) async {
    final db = await instance.database;

    return await db.delete(
      masterTable,
      where: '${WorldInstanceFields.year} = ?',
      whereArgs: [year],
    );
  }

  Future<int> deleteAll() async {
    final db = await instance.database;

    return await db.delete(masterTable);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}