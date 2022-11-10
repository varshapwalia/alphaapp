import 'package:alpha_app/util/endpoints.dart';
import 'package:flutter/foundation.dart';

/*Developer Name - Navjyot Singh*/

class NewsListAPIProvider {

  Future<Map<String, dynamic>> getNewsList() async {
    var data = await ApiCallV2().getCall(Endpoints.newsListUrl);
    if (kDebugMode) {
      print("we got the data $data");
    }
    return data;
  }
}
