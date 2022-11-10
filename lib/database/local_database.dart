import 'dart:developer';

import 'package:alpha_app/data_mapper/news_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class TableDataGateway{
  static final TableDataGateway _instance = TableDataGateway.internal();

  TableDataGateway.internal();

  factory TableDataGateway() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Database localDatabase;
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, "local_database.db");

      localDatabase = await openDatabase(
        path,
        version: 4,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      var databasesPath = await getDatabasesPath();
      await deleteDatabase(join(databasesPath, "local_database.db"));

      String path = join(databasesPath, "local_database.db");
      localDatabase = await openDatabase(
        path,
        version: 4,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );

    }
    return localDatabase;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE news_list(author TEXT, title TEXT, description TEXT, url TEXT, urlToImage TEXT, publishedAt TEXT, content TEXT,name TEXT)");
  }

  void createAdditionalRuntimeDB() async {
    _db = await initDb();
  }

  void _onUpgrade(Database db, int version, int newVersion) async {
    var dbClient = db;
    await dbClient.rawQuery("DROP TABLE IF EXISTS news_list");
    await db.execute(
        "CREATE TABLE news_list(author TEXT, title TEXT, description TEXT, url TEXT, urlToImage TEXT, publishedAt TEXT, content TEXT,name TEXT)");
  }

  void saveResponse(List<NewsModel> newsList) async {

    var dbClient = await db;
    try{
      for (var element in newsList) {
        String author = element.author.toString().replaceAll(RegExp('[^A-Za-z0-9,]'), '').replaceAll(":", "").replaceAll(",", "");
        String title = element.title.toString().replaceAll(RegExp('[^A-Za-z0-9,]'), '').replaceAll(":", "").replaceAll(",", "");
        String description = element.description.toString().replaceAll(RegExp('[^A-Za-z0-9,]'), '').replaceAll(":", "").replaceAll(",", "");
        String content = element.content.toString().replaceAll(RegExp('[^A-Za-z0-9,]'), '').replaceAll(":", "").replaceAll(",", "");
        String name = element.name.toString().replaceAll(RegExp('[^A-Za-z0-9,]'), '').replaceAll(":", "").replaceAll(",", "");
        dbClient!.rawInsert('INSERT INTO news_list(author, title, description, url, urlToImage, publishedAt, content, name) VALUES( ${author}, ${title}, ${description}, ${element.url.toString()}, ${element.urlToImage.toString()}, ${element.publishedAt.toString()}, ${content}, ${name})') ;
        print("We are here bro");
      }
    }catch(e){
      print("exception si "+e.toString());
    }

  }




  // Future<int> saveNewsData(NewsModel newsModel) async {
  //   var dbClient = await db;
  //   int res =
  //   await dbClient!.insert("customize_icons_table", newsModel.toMap());
  //   return res;
  // }

  Future getNewsData() async {
    print("we are here baba");
    var dbClient = await db;
    List responseList =[];
    try{
      responseList = await dbClient!.rawQuery("SELECT * from news_list");
    }catch(e){
      print("e is is "+e.toString());
    }

    // print("response list is "+responseList.toString());
    return responseList;
  }

// Future<int> updateResponse(String url, String response, int time) async {
//   var dbClient = await db ;
//   return await dbClient!.update(
//       "urlresponse", {"response": response, "time": time},
//       where: "url = ?", whereArgs: [url]);
// }

// Future<int> deleteResponse(String url) async {
//   var dbClient = await db;
//   int res = await dbClient!
//       .delete("urlresponse", where: "url = ?", whereArgs: [url]);
//   return res;
// }
}