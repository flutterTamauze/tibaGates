import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:clean_app/api/app_exceptions.dart';
import 'package:clean_app/api/base_client.dart';
import 'package:clean_app/api/base_exception_handling.dart';

import '../../../Data/Models/manager/invitationType_model.dart';
import '../../../Data/Models/manager/invitation_model.dart';
import '../../../Data/Models/admin/prices.dart';

import '../../../Utilities/Constants/constants.dart';
import '../../../api/sharedPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class PricesProv with ChangeNotifier, BaseExceptionHandling {
  List<PricesModel> pricesObjects = [];

  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };

  Future<dynamic> deletePrice(int priceId, String userId) async {
    String data = '';

    try {

      var response = await BaseClient()
          .delete(BASE_URL, '/api/Guest/DeleteOwner?ID=$priceId&UserID=$userId')
          .catchError(handleError);


      var decodedRes = jsonDecode(response);

      debugPrint('response is $decodedRes');
      debugPrint('message is ${decodedRes['message']}');

      if (decodedRes['message'] == 'Success') {
        data = 'success';

        pricesObjects.removeWhere((element) => element.id == priceId);
      }

      notifyListeners();
      return data;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> addPrices(
      String type, double price, double priceInHoliday) async {
    String data = '';

    try {
      var response = await BaseClient().post(BASE_URL, '/api/Guest/AddOwner', {
        'type': type,
        'price': price,
        'priceInHoliday': priceInHoliday
      }).catchError(handleError);

      debugPrint('response $response');

      var decodedRes = jsonDecode(response);

      debugPrint('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> updatePrices(
      int id, String type, double price, double priceInHoliday) async {
    String data = '';

    try {
      var response = await BaseClient().put(
          BASE_URL, '/api/Guest/UpdateOwner', {
        'id': id,
        'type': type,
        'price': price,
        'priceInHoliday': priceInHoliday
      }).catchError(handleError);

      debugPrint('response $response');

      var decodedRes = jsonDecode(response);

      debugPrint('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> getPrices() async {
    String data = '';
    debugPrint('a');

    try {
      var response = await BaseClient()
          .get(BASE_URL, '/api/Guest/GetOwners')
          .catchError(handleError);

      debugPrint(' response is ${jsonDecode(response)['response']}');
      debugPrint(' message is ${jsonDecode(response)['message']}');

      if (jsonDecode(response)['message'] == 'Success') {
        data = 'Success';

        var pricesObj = jsonDecode(response)['response'] as List;

        pricesObjects =
            pricesObj.map((item) => PricesModel.fromJson(item)).toList();

        pricesObjects = pricesObjects.reversed.toList();
        debugPrint('prices length is ${pricesObjects.length}');
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e);
    }
  }
}
