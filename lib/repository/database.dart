import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

Map<int, String> scripts = {
  1: ''' CREATE TABLE tarefas (
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         descricao TEXT,
         horario TEXT,
         data DATETIME,
         concluido INTEGER
  );''',
  2: ''' CREATE TABLE pontos (
        ponto INTEGER
  );'''
};

class DataBaseSQLite {
  static Database? db;

  Future<Database> getDataBase() async {
    if (db == null) {
      return await iniciarBancoDados();
    } else {
      return db!;
    }
  }

  Future iniciarBancoDados() async {
    var pathDatabase = path.join(await getDatabasesPath(), 'database.db');

    db = await openDatabase(pathDatabase, version: scripts.length,
        onCreate: (Database db, int version) async {
      for (var i = 1; i <= scripts.length; i++) {
        await db.execute(scripts[i]!);
        debugPrint(scripts[i]);
      }
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion + 1; i <= scripts.length; i++) {
        await db.execute(scripts[i]!);
        debugPrint(scripts[i]);
      }
    });

    return db;
  }
}
