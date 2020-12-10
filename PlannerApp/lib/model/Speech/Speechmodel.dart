import 'package:sqflite/sqflite.dart';
import 'speech.dart';
import 'dbspeech.dart';
class Speechmodel {
  Future<List<speech>> getAllspeech() async {
    final db = await DBUtils.dtbs();

    final List<Map<String, dynamic>> speeches = await db.query('Speechlist');
    List<speech> final_result = [];


    if (speeches.length > 0) {
      for (int i = 0; i < speeches.length; i++) {
        {
          final_result.add(speech.from_map(speeches[i]));
        }
      }
      return final_result;
    }
  }

  Future<int> insertspeech(speech newspeech) async {
    final db = await DBUtils.dtbs();

    return db.insert('Speechlist',
        newspeech.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<void> updatespeech(speech updatedspeech) async{
    final db=await DBUtils.dtbs();
    int id=updatedspeech.toMap()['id'];
    print(id);
    db.update('Speechlist', updatedspeech.toMap(),where: 'id=?',whereArgs: [id]);
  }
  Future<void> deletespeech(int id) async{
    final db=await DBUtils.dtbs();
    db.delete('Speechlist',where:'id=?',whereArgs: [id]);
  }
}
