import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

class DbProvider {
  Database db;

  init() async {
    print('init db');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "urls.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        print('rebuilding schema!!');
        newDb.execute("""
          CREATE TABLE urls(
            id INTEGER PRIMARY KEY,
            url TEXT UNIQUE
          )
        """);
      },
    );
    print('db created ${db.toString()}');
  }

  Future<List<String>> fetchUrls() async {
    if(db == null)
    await init();
    print('calling query');
    List<Map> results = await db.query(
      'urls',
      columns: ['url'],
    );
    List<String> urls = [];
    results.forEach((Map<dynamic, dynamic> res) {
      urls.add(res['url']);
    });
    print('urls: ${urls.toString()}');
    return urls;
  }

  addUrl(String url) async{
    if(db == null)
      await init();
    Map<String, dynamic> data = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'url': url
    };
    await db.insert('urls', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteUrl(String url) async{
    if(db == null)
      await init();
    print('calling query');
    var res = await db.rawDelete('DELETE FROM urls WHERE url = ?', [url]);
    print('delete: ${res.toString()}');
  }
}
