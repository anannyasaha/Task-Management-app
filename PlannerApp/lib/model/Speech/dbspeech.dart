import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils{
  static Future<Database> dtbs() async {
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'speech.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE Table Speechlist(id INTEGER PRIMARY KEY,Description TEXT)');
      },
      version: 1,
    );
    return database;
  }

}