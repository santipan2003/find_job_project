import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'db_repositories/user_repo.dart';

class DatabaseHelper{

  //Singleton pattern
  static final DatabaseHelper _instance =
  DatabaseHelper._internal();


  factory DatabaseHelper() {
    return _instance;
  }
  DatabaseHelper._internal();

  Database? _database;

  Database getDatabase(){
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "dating_demo.db");
    _database =  await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await createUserTable(db);
        });
  }

  Future createUserTable(Database db) async{
    await db.execute(
        '''CREATE TABLE ${UserRepository.tableName}(
            ${UserRepository.id} INTEGER PRIMARY KEY,
            ${UserRepository.name} TEXT,
            ${UserRepository.title} TEXT,
            ${UserRepository.age} TEXT,
            ${UserRepository.location} TEXT,
            ${UserRepository.image} TEXT
            )''');
  }
}