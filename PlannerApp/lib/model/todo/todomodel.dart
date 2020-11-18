import 'package:sqflite/sqflite.dart';

import 'dbutils.dart';
import 'todo.dart';
import 'addtodopage.dart';
class todomodel{


  Future<List<todo>> deleteoldtodos() async{
    final db=await DBUtils.dtbs();

    final List<Map<String, dynamic>> todos=await db.query('todolist');
    List<todo> old_todo=[];
    DateTime today = new DateTime.now();

    String olddatestring = toolddateString(today);
    if (todos.length > 0) {
      for (int i = 0; i < todos.length; i++) {
        if (todo
            .from_map(todos[i])
            .date == olddatestring) {
          old_todo.add(todo.from_map(todos[i]));

        }
      }
  }
    return old_todo;}
  Future<List<todo>> getAlltodos() async {
    final db = await DBUtils.dtbs();

    final List<Map<String, dynamic>> todos = await db.query('todolist');
    List<todo> final_result = [];
    DateTime today = new DateTime.now();

    String olddatestring = toolddateString(today);
    if (todos.length > 0) {
      for (int i = 0; i < todos.length; i++) {
        if (todo
            .from_map(todos[i])
            .date != olddatestring) {
          final_result.add(todo.from_map(todos[i]));
        }
      }
      return final_result;
    }
  }
  Future<List<todo>> getassignedtodos() async {
    final db = await DBUtils.dtbs();

    final List<Map<String, dynamic>> todos = await db.query('todolist');
    List<todo> assigned_list = [];

    if (todos.length > 0) {
      for (int i = 0; i < todos.length; i++) {
        if (todo
            .from_map(todos[i])
            .assignedto != "") {
          assigned_list.add(todo.from_map(todos[i]));
        }
      }
      return assigned_list;
    }
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

    String tomorrowstring = toTomorowString(today);
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
    print("deleted");
    final db=await DBUtils.dtbs();
    db.delete('todolist',where:'id=?',whereArgs: [id]);
  }
}