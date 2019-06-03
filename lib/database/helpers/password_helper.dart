export 'package:pw_project/database/entities/password_entity.dart';

import 'package:pw_project/database/entities/password_entity.dart';
import 'package:pw_project/models/password_model.dart';
import 'package:sqflite/sqflite.dart';

final String databaseName = 'PasswordDatabase.db';

final String tablePasswords = 'passwords';
final String columnId = '_id';
final String columnService = 'service';
final String columnPassword = 'password';
final String columnPosition = 'position';

final String createPasswordTable = '''
    CREATE TABLE $tablePasswords (
      $columnId integer primary key autoincrement,
      $columnService text not null,
      $columnPassword test not null,
      $columnPosition integer not null
    )
''';

final int databaseVersion = 1;

class PasswordDatabaseHelper {

  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: databaseVersion,
        onCreate: (Database db, int version) async {
      await db.execute(createPasswordTable);
    });
  }

  Future<List<PasswordEntity>> getAll() async {
    List<Map> maps = await db.query(tablePasswords,
      columns: [columnId, columnService, columnPassword, columnPosition],
      );
    return maps.map((map) => PasswordEntity.fromMap(map)).toList();
  }

  Future<int> insert(PasswordModel model) async {
    return db.insert(tablePasswords, model.toEntity().toMap());
  }

  Future<int> delete(int id) async {
    return await db.delete(tablePasswords, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    return await db.delete(tablePasswords);
  }

  Future<int> update(PasswordModel model) async {
    return await db.update(tablePasswords, model.toEntity().toMap(),
        where: '$columnId = ?', whereArgs: [model.id]);
  }

  Future close() async => db.close();

}