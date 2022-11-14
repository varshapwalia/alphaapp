import 'package:alpha_app/domain_object/news_model.dart';
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
      String path = join(databasesPath, "local_database1.db");

      localDatabase = await openDatabase(
        path,
        version: 4,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      var databasesPath = await getDatabasesPath();
      await deleteDatabase(join(databasesPath, "local_database1.db"));

      String path = join(databasesPath, "local_database1.db");
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
    print("we are coming her ");
    await db.execute("CREATE TABLE source(id INTEGER PRIMARY KEY AUTOINCREMENT,source_id TEXT, source_name TEXT)");
    await db.execute("CREATE TABLE author(id INTEGER PRIMARY KEY AUTOINCREMENT, author_name TEXT,source_id INTEGER, FOREIGN KEY (source_id) REFERENCES source (id))");
    await db.execute("CREATE TABLE news(id INTEGER PRIMARY KEY AUTOINCREMENT,source_id INTEGER, author_id INTEGER,title TEXT, description TEXT, url TEXT, urlToImage TEXT, publishedAt TEXT, content TEXT, FOREIGN KEY (source_id) REFERENCES source (id),  FOREIGN KEY (author_id) REFERENCES author (id))");
    print("table created");
  }

  void createAdditionalRuntimeDB() async {
    _db = await initDb();
  }

  void _onUpgrade(Database db, int version, int newVersion) async {
    var dbClient = db;
    await dbClient.rawQuery("DROP TABLE IF EXISTS news_list");
    await db.execute(
        "CREATE TABLE news_list(id TEXT PRIMARY KEY, author TEXT, title TEXT, description TEXT, url TEXT, urlToImage TEXT, publishedAt TEXT, content TEXT,name TEXT)");
  }

  void saveResponse(List<NewsModel> newsList) async {

    var dbClient = await db;
    try{
      for (var element in newsList) {
        String sourceId = element.source.id;
        String sourceName = element.source.name;
        String author = element.author.toString();
        String description = element.description.toString();
        String url = element.url.toString();
        String urlToImage = element.urlToImage.toString();
        String date = element.publishedAt.toString();
        String content = element.content.toString();
        String title = element.title.toString();

        dbClient!.rawInsert('INSERT INTO source(source_id,source_name) VALUES("$sourceId","$sourceName")') ;
        var result =await dbClient.rawQuery('SELECT last_insert_rowid()');
        int lastSourceId =int.parse(result[0]['last_insert_rowid()'].toString()) ;
        dbClient.rawInsert('INSERT INTO author(author_name,source_id) VALUES("$author",$lastSourceId)') ;
        result =await dbClient.rawQuery('SELECT last_insert_rowid()');
        int lastAuthorId =int.parse(result[0]['last_insert_rowid()'].toString()) ;
        dbClient.rawInsert('INSERT INTO news(author_id,source_id, title, description, url, urlToImage, publishedAt, content) VALUES($lastAuthorId,$lastSourceId,"$title","$description","$url","$urlToImage","$date","$content")') ;
      }
    }catch(e){
      print("exception caught is "+e.toString());
    }
  }

  Future getNewsData() async {
    var dbClient = await db;
    List responseList =[];
    try{
      responseList = await dbClient!.rawQuery("SELECT * FROM news INNER JOIN author ON news.author_id = author.id INNER JOIN source ON news.source_id = source.id");
    }catch(e){
      print("exception caught is "+e.toString());
    }
    return responseList;
  }


  Future getNewsSearch(String searchString) async {
    var dbClient = await db;
    List responseList =[];
    try{
      responseList = await dbClient!.rawQuery("SELECT * FROM news INNER JOIN author ON news.author_id = author.id INNER JOIN source ON news.source_id = source.id WHERE title LIKE '$searchString%'");
    }catch(e){
      print("exception caught is "+e.toString());
    }
    return responseList;
  }
}