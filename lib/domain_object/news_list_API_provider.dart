import 'package:alpha_app/api/api_call.dart';
import 'package:alpha_app/util/endpoints.dart';

class NewsListAPIProvider {

  Future<Map<String, dynamic>> getNewsList() async {
    var data = await ApiCallV2().getCall(Endpoints.newsListUrl);
    return data;
  }
}