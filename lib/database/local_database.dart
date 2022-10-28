import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class TableDataGateway{
  static final TableDataGateway _instance = new TableDataGateway.internal();

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
        "CREATE TABLE customize_icons_table(id INTEGER PRIMARY KEY, url TEXT, response TEXT)");

  }

  void createAdditionalRuntimeDB() async {
    _db = await initDb();
  }

  void _onUpgrade(Database db, int version, int newVersion) async {
    var dbClient = db;

    await dbClient.rawQuery("DROP TABLE IF EXISTS customize_icons_table");

    await db.execute(
        "CREATE TABLE customize_icons_table(id INTEGER PRIMARY KEY, url TEXT, response TEXT)");
  }

  Future<int> saveResponse(UrlResponse urlResponse) async {
    var dbClient = await db;
    int res = await dbClient!.insert("urlresponse", urlResponse.toMap());
    return res;
  }

  Future<int> saveNewsData(NewsModel newsModel) async {
    var dbClient = await db;
    int res =
    await dbClient!.insert("customize_icons_table", newsModel.toMap());
    return res;
  }

  Future getNewsData(String url) async {
    var dbClient = await db;

    //----------add table if not exists-------
    await dbClient!.execute(
        "CREATE TABLE IF NOT EXISTS dashboard_search_recent_table(id INTEGER PRIMARY KEY, url TEXT, response TEXT)");

    List resposeList = await dbClient.rawQuery(
        "SELECT * from dashboard_search_recent_table WHERE url = ?", [url]);
    return resposeList.map((u) => NewsModel.map(u)).toList();
  }

  Future<int> updateResponse(String url, String response, int time) async {
    var dbClient = await db ;
    return await dbClient!.update(
        "urlresponse", {"response": response, "time": time},
        where: "url = ?", whereArgs: [url]);
  }

  Future<int> deleteResponse(String url) async {
    var dbClient = await db;
    int res = await dbClient!
        .delete("urlresponse", where: "url = ?", whereArgs: [url]);
    return res;
  }
}
