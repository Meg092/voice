import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:versatile_voice/db_voice/voice_entity.dart';

class DBVoice extends GetxService {
  late Database dbBase;

  Future<DBVoice> init() async {
    await createVoiceDB();
    return this;
  }

  createVoiceDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'voice.db');

    dbBase = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await createVoiceTable(db);
    });
  }

  createVoiceTable(Database db) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS voice (id INTEGER PRIMARY KEY, createdTime TEXT, type INTEGER, voice INTEGER, word TEXT, voicePath TEXT)');
  }

  insertVoice(VoiceEntity entity) async {
    final id = await dbBase.insert('voice', {
      'createdTime': entity.createdTime.toIso8601String(),
      'type': entity.type,
      'voice': entity.type,
      'word': entity.word,
      'voicePath': entity.voicePath,
    });
    return id;
  }

  cleanOriginalData() async {
    await dbBase.delete(
      'voice',
      where: 'type = ?',
      whereArgs: [1],
    );
  }

  cleanTransformationData() async {
    await dbBase.delete(
      'voice',
      where: 'type = ?',
      whereArgs: [2],
    );
  }

  cleanAllData() async {
    await dbBase.delete(
      'voice',
    );
  }

  Future<List<VoiceEntity>> getVoicesAllData() async {
    var result = await dbBase.query('voice', orderBy: 'createdTime DESC');
    return result.map((e) => VoiceEntity.fromMap(e)).toList();
  }
}
