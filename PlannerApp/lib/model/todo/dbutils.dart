import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils{
  static Future<Database> dtbs() async{
    var database=openDatabase(path.join(await getDatabasesPath(),'todolist_manager.db'),
      onCreate:(db,version){
        db.execute('CREATE Table todolist(id INTEGER PRIMARY KEY,description TEXT,priority TEXT,date TEXT NULL,time Text NULL,assignedto TEXT null)');
        db.execute('CREATE Table oldtodolist(id INTEGER PRIMARY KEY,description TEXT,priority TEXT,date TEXT NULL,time Text NULL,assignedto TEXT null)');
        },
      version:2,
    );
    return database;
  }
}