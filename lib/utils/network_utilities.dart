import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkUtilities {
  BuildContext context;
  NetworkUtilities(this.context);

  executeGetRequest(String url, Map<String, dynamic>? queryParameters,
      BuildContext context) async {
    try {
      var uri = Uri.parse(url);
      uri = uri.replace(queryParameters: queryParameters);

      http.Response response = await http.get(uri);

      return await json.decode(response.body);
    } catch (e) {
      debugPrint('NetworkUtilities > Caught exception : ${e.toString()}');
    }
  }
}
