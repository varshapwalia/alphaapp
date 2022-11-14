import 'dart:async';
import 'package:alpha_app/util/api_response_handler.dart';
import 'package:http/http.dart' as http;

class ApiCallV2 {

  Future<Map<String, dynamic>> getCall(String endpoint) async {

    var client = http.Client();
    String url =  endpoint;

    try {
      var uriResponse = await client.get(
        Uri.parse(url)
      );

        return ApiResponseHandler.output(uriResponse);

    } catch (error) {
      return ApiResponseHandler.outputError();
    }
  }
}