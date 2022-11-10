import 'dart:async';
import 'package:http/http.dart' as http;

bool production = false;
bool test = true;
bool dev = false;
bool isLogout = true;


class ApiCallV2 {
  // static String baseUrl = initialEP;

  // TableDataGateway db =  TableDataGateway();

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


  // Future<Map<String, dynamic>> getCallSaveRes(String endpoint) async {
  //   String url = baseUrl + endpoint;
  //
  //   //this try catch is for handling the db error if any
  //   try {
  //     var client = http.Client();
  //     List list = await (db.getResponse(url, lastTallySync));
  //     if (list.isEmpty) {
  //       try {
  //         var uriResponse = await client.get(
  //           Uri.parse(url),
  //           headers: {
  //             "Authorization": preferences
  //                 .getString(PreferencesConstants.ACCESS_TOKEN_PREFERENCES)!,
  //             "organizationId": preferences
  //                 .getString(PreferencesConstants.ORG_ID_PREFERENCES)!,
  //             "Content-Type": "application/json",
  //           },
  //         );
  //
  //
  //         if (uriResponse.statusCode == 200 || uriResponse.statusCode == 201) {
  //           db.deleteResponse(url);
  //           var urlResponse = UrlResponse(uriResponse.body, url, lastTallySync);
  //           db.saveResponse(urlResponse);
  //           return ApiResponseHandler.output(uriResponse);
  //         } else if (uriResponse.statusCode == 401) {
  //           bool isPresent = await getAccessToken();
  //
  //           if (isPresent) return await getCallSaveRes(endpoint);
  //         } else {
  //           return ApiResponseHandler.output(uriResponse);
  //         }
  //       } catch (error) {
  //         return ApiResponseHandler.outputError();
  //       }
  //     } else {
  //       Map<String, dynamic> res = Map<String, dynamic>();
  //       res["statusCode"] = 200;
  //       res["result"] = list.last.response;
  //       res["error"] = null;
  //       return res;
  //     }
  //   } catch (e) {
  //     await FirebaseCrashlytics.instance.recordError(
  //         "DataBase-Exception-API-Call", StackTrace.fromString(e.toString()),
  //         reason: 'a fatal DB error');
  //
  //     return getCall(endpoint);
  //   }
  //   return ApiResponseHandler.outputError();
  //
  // }

  // Future<Map<String, dynamic>> postCallSaveRes(
  //     String endpoint, dynamic payload) async {
  //   // LoginResponse user = await getUserFromDb();
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //
  //   var client = new http.Client();
  //   String url = baseUrl + endpoint;
  //
  //   List list = await (db.getPostResponse(url, lastTallySync, payload));
  //
  //   if (list.isEmpty) {
  //     try {
  //       var uriResponse = await client.post(
  //         Uri.parse(url),
  //         body: payload,
  //         headers: {
  //           "Authorization": preferences
  //               .getString(PreferencesConstants.ACCESS_TOKEN_PREFERENCES)!,
  //           "organizationId":
  //           preferences.getString(PreferencesConstants.ORG_ID_PREFERENCES)!,
  //           "Content-Type": "application/json",
  //         },
  //       );
  //
  //       if (uriResponse.statusCode == 200 || uriResponse.statusCode == 201) {
  //         db.deletePostResponse(url);
  //         var urlResponse =
  //         PostUrlResponse(uriResponse.body, payload, url, lastTallySync);
  //         db.savePostResponse(urlResponse);
  //         return ApiResponseHandler.output(uriResponse);
  //       } else if (uriResponse.statusCode == 401) {
  //         await getAccessToken();
  //         return await postCall(endpoint, payload);
  //       } else {
  //         return ApiResponseHandler.output(uriResponse);
  //       }
  //     } catch (error) {
  //       return ApiResponseHandler.outputError();
  //     }
  //   } else {
  //     Map<String, dynamic> res = Map<String, dynamic>();
  //     res["statusCode"] = 200;
  //     res["result"] = list.last.response;
  //     res["error"] = null;
  //     return res;
  //   }
  //
  // }
}
