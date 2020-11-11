import 'package:sqflite/sqflite.dart';

import 'dbutils.dart';
import 'todo.dart';
class todomodel{
  Future<List<todo>> getAlltodos() async{
    final db=await DBUtils.dtbs();

    final List<Map<String, dynamic>> todos=await db.query('todolist');
    List<todo> final_result=[];
    if(todos.length>0) {
      for (int i = 0; i<todos.length;i++){
        final_result.add(todo.from_map(todos[i]));
      }
    }
    return final_result;
  }
  Future<int> inserttodo(todo newtodo) async{
    final db=await DBUtils.dtbs();
    return db.insert('todolist',
        newtodo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<void> updatetodo(todo updatedtodo) async{
    final db=await DBUtils.dtbs();
    db.update('todolist', updatedtodo.toMap(),where: 'id=?',whereArgs: [updatedtodo.id]);
  }
  Future<void> deletetodo(int id) async{
    final db=await DBUtils.dtbs();
    db.delete('todolist',where:'id=?',whereArgs: [id]);
  }
}