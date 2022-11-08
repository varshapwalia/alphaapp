import 'dart:convert';

import 'package:app_flutter_project/bloc/news_list_bloc/service/news_list_API_provider.dart';
import 'package:app_flutter_project/data_mapper/news_model.dart';
import 'package:app_flutter_project/database/local_database.dart';
import 'package:app_flutter_project/util/custom_exception.dart';


/*Developer Name - Navjyot Singh*/

class NewsListRepo {
  final NewsListAPIProvider _newsListApiProvider = NewsListAPIProvider();

  TableDataGateway db = TableDataGateway();

//---------------fetching contact details here----------
  Future<List<NewsModel>> fetchNewsList() async {
    List<NewsModel> newsList;

    var data =
        await _newsListApiProvider.getNewsList();

    var status = data['statusCode'];

    //----------if status is 200 then do what we want to do to return the data-----------

    if (status == 200) {
      var output;
      if (data['result'] != null) output = json.decode(data['result'])['articles'];

      newsList = (output as List)
          .map((e) => NewsModel.fromJson(e))
          .toList();
      db.initDb();
      db.saveResponse();


      return newsList;
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


}
