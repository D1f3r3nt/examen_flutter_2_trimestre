import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/person_model.dart';

/// Clase dedicada a guardar los datos en la base de datos SQFLITE,
/// para asi tener persistencia
class LocalDatabase {
  static Database? _database;

  static final LocalDatabase db = LocalDatabase._();

  LocalDatabase._();

  Future<Database> get database async {
    if (_database == null) _database = await initDb();

    return _database!;
  }

  /// Para iniciar la base de datos
  Future<Database> initDb() async {
    // Obtenir es path
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    // IMPORTANTE: Hay que poner el nombre de la base de datos
    final path = join(documentDirectory.path, 'Persons.db');
    print(path);

    // Creació de la BBDD
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE Persons(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT,
          address TEXT,
          phone TEXT,
          photo TEXT
        )
        ''');
      },
    );
  }

  // Amb JSON
  Future<int> insert(PersonModel model) async {
    final db = await database;

    final res = await db.insert('Persons', model.toMap());

    return res;
  }

  // Collir tots els camps
  Future<List<PersonModel>> getAll() async {
    final db = await database;

    final res = await db.query('Persons');

    return res.isNotEmpty
        ? res.map((e) => PersonModel.fromMap(e)).toList()
        : [];
  }

  // Per actualitzar
  Future<int> update(PersonModel model) async {
    final db = await database;
    final res = db.update(
      'Cars',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );

    return res;
  }

  // Per borrar per ID
  Future<int> deleteById(int id) async {
    final db = await database;
    final res = await db.delete('Persons', where: 'id = ?', whereArgs: [id]);

    return res;
  }
}
