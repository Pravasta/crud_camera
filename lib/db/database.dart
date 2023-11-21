import 'dart:io';

import 'package:latihan_crud/model/db_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInstance {
  final String databaseName = 'product.db';
  final int databaseVersion = 1;

  // Product
  final String tableName = 'product_table';
  final String id = 'id';
  final String image = 'image';
  final String name = 'name';
  final String price = 'price';
  final String createdAt = 'created_at';
  final String updatedAt = 'updated_at';

  Database? _db;

  Future<Database> database() async {
    // db baru / db yang pernah dibuat
    if (_db != null) return _db!;

    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    // document tersendiri dalam database
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, databaseName);

    return openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tableName (
          $id INTEGER PRIMARY KEY,
          $image TEXT NULL,
          $name TEXT,
          $price INTEGER,
          $createdAt TEXT NULL,
          $updatedAt TEXT NULL
        ) 
      ''');
  }

  Future<List<DbModel>> getAllProduct() async {
    // memanggil database
    if (_db == null) {
      await database();
    }

    final data = await _db!.query(tableName);

    List<DbModel> result = data.map((e) => DbModel.fromJson(e)).toList();
    return result;
  }

  // Insert data kita ke database
  Future<int> insert(Map<String, dynamic> data) async {
    final query = await _db!.insert(
      tableName,
      data,
    );

    return query;
  }

  // update
  Future<int> update(int idData, Map<String, dynamic> data) async {
    final query = await _db!.update(
      tableName,
      data,
      where: '$id = ?',
      whereArgs: [
        idData,
      ],
    );

    return query;
  }

  Future<int> delete(int idData) async {
    final query = await _db!.delete(
      tableName,
      where: '$id = ?',
      whereArgs: [idData],
    );

    return query;
  }
}
