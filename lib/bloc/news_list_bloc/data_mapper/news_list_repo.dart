import 'dart:convert';

import 'package:alpha_app/domain_object/news_list_API_provider.dart';
import 'package:alpha_app/domain_object/news_model.dart';
import 'package:alpha_app/table_data_gateway/local_database.dart';
import 'package:alpha_app/util/custom_exception.dart';

class NewsListRepo {
  final NewsListAPIProvider _newsListApiProvider = NewsListAPIProvider();

  TableDataGateway db = TableDataGateway();

  //---------------fetching news here----------
  Future<List<NewsModel>> fetchNewsList() async {
    List<NewsModel> newsList;

    var data = await _newsListApiProvider.getNewsList();

    var status = data['statusCode'];

    //----------if status is 200 then do what we want to do to return the data-----------

    if (status == 200) {
      var output;
      if (data['result'] != null) {
        output = json.decode(data['result'])['articles'];
      }

      newsList = (output as List).map((e) => NewsModel.fromJson(e)).toList();

      db.saveResponse(newsList);
      List result = await db.getNewsData();
      List<NewsModel> resultList = [];
      List finalResult = queryToMap(result);
      for (var element in finalResult) {
        resultList.add(NewsModel(
            Source(element['source_id'], element['source_name']),
            element['author_name'],
            element['title'],
            element['description'],
            element['url'],
            element['urlToImage'],
            element['publishedAt'],
            element['content']));
      }

      return resultList;
    }
    //------is status is 400 throw this custom exception error------------
    else if (status == 400) {
      throw CustomException(400, 'Some error occurred');
    }

    //------is status is 404 throw this custom exception error------------
    else if (status == 404) {
      throw CustomException(404, 'Some error occurred');
    }

    //------is status is 401 throw this custom exception error------------
    else if (status == 401) {
      throw CustomException(401, 'You are unauthorised to use this');
    }

    //------is status is 500 throw this custom exception error------------
    else if (status == 500) {
      throw CustomException(500, 'Server error occurred');
    }

    //------is status code is unidentified throw this custom exception error------------
    else {
      throw CustomException(0, 'Some unexpected error occurred');
    }
  }
  
  //---------------searching news here----------
  Future<List<NewsModel>> searchNewsList(String searchString) async {
    List result = await db.getNewsSearch(searchString);
    List<NewsModel> resultList = [];
    List finalResult = queryToMap(result);
    for (var element in finalResult) {
      resultList.add(NewsModel(
          Source(element['source_id'], element['source_name']),
          element['author_name'],
          element['title'],
          element['description'],
          element['url'],
          element['urlToImage'],
          element['publishedAt'],
          element['content']));
    }
    return resultList;
  }

  List queryToMap(var result) {
    List x = [];
    result.forEach((r) => x.add(Map<String, dynamic>.from(r)));
    return x;
  }
}