import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../main.dart';
import 'app_exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class BaseClient {
  static const int TIME_OUT_DURATION = 20;

  // GET
  Future<dynamic> get(String baseUrl, String api) async {
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}'
      }).timeout(const Duration(seconds: TIME_OUT_DURATION));
      print('status code is ${response.statusCode}');
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Api not responded in time ', uri.toString());
    }
  }

  // POST
  Future<dynamic> post(String baseUrl, String api, [dynamic payloadObj]) async {
    var uri = Uri.parse(baseUrl + api);
    try {
      var response =
          await http.post(uri, body: json.encode(payloadObj), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}'
      }).timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Api not responded in time ', uri.toString());
    }
  }


  // PUT
  Future<dynamic> put(String baseUrl, String api, dynamic payloadObj) async {
    var uri = Uri.parse(baseUrl + api);
    debugPrint('payload obj $payloadObj');
    try {
      var response =
          await http.put(uri, body: json.encode(payloadObj), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}'
      }).timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Api not responded in time ', uri.toString());
    }
  }

  // DELETE
  Future<dynamic> delete(String baseUrl, String api) async {
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await http.delete(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}'
      }).timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Api not responded in time ', uri.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        log('RESPONSE IS $responseJson');
        return responseJson;
        break;

      case 400:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request.url.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred with code : ${response.statusCode}',
            response.request.url.toString());
    }
  }
}
