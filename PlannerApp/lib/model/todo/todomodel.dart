import 'package:sqflite/sqflite.dart';

import 'dbutils.dart';
import 'todo.dart';
import 'addtodopage.dart';
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
  Future<List<todo>> gettodaytodos() async {
    final db = await DBUtils.dtbs();

    final List<Map<String, dynamic>> todos = await db.query('todolist');
    List<todo> today_list = [];
    DateTime today = new DateTime.now();

    String todaystring = toDateString(today);
    if (todos.length > 0) {
      for (int i = 0; i < todos.length; i++) {
        if (todo
            .from_map(todos[i])
            .date == todaystring) {
          today_list.add(todo.from_map(todos[i]));
        }
      }
      return today_list;
    }
  }
  Future<List<todo>> gettoomorrowtodos() async {
    final db = await DBUtils.dtbs();

    final List<Map<String, dynamic>> todos = await db.query('todolist');
    List<todo> tomorrow_list = [];
    DateTime today = new DateTime.now();

    String tomorrowstring = toTomoroowString(today);
    if (todos.length > 0) {
      for (int i = 0; i < todos.length; i++) {
        if (todo
            .from_map(todos[i])
            .date == tomorrowstring) {
          tomorrow_list.add(todo.from_map(todos[i]));
        }
      }
      return tomorrow_list;
    }
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