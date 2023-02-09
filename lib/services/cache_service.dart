import 'package:gallery/models/cache_image_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CacheService{
  static final CacheService instance = CacheService._init();

  static Database? _database;

  CacheService._init();
  // Get database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('images.db');
    return _database!;
  }

  // Init database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $tableImages ( 
      ${CacheImageFields.id} $idType, 
      ${CacheImageFields.idImage} $textType,
      ${CacheImageFields.imageUrl} $textType
      )
    ''');
  }

  Future<CacheImageModel> create(CacheImageModel cache) async {
    final db = await instance.database;

    // final json = CacheImageModel.toJson();
    // final columns =
    //     '${CacheImageModelFields.title}, ${CacheImageModelFields.description}, ${CacheImageModelFields.time}';
    // final values =
    //     '${json[CacheImageModelFields.title]}, ${json[CacheImageModelFields.description]}, ${json[CacheImageModelFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableImages, cache.toJson());
    return cache.copy(id: id);
  }

  Future<CacheImageModel> readCacheImage(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableImages,
      columns: CacheImageFields.values,
      where: '${CacheImageFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CacheImageModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<CacheImageModel>> readAllCacheImages() async {
    final db = await instance.database;

    const orderBy = '${CacheImageFields.idImage} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableCacheImageModels ORDER BY $orderBy');

    final result = await db.query(tableImages);

    return result.map((json) => CacheImageModel.fromJson(json)).toList();
  }

  Future<int> update(CacheImageModel cache) async {
    final db = await instance.database;

    return db.update(
      tableImages,
      cache.toJson(),
      where: '${CacheImageFields.id} = ?',
      whereArgs: [cache.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableImages,
      where: '${CacheImageFields.idImage} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    // final db = await instance.database;
    //
    // db.close();
  }
}