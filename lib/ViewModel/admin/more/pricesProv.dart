import 'dart:convert';
import 'dart:io';
import 'package:clean_app/Data/Models/manager/invitationType_model.dart';
import 'package:clean_app/Data/Models/manager/invitation_model.dart';
import 'package:clean_app/Data/Models/admin/prices.dart';

import '../../../Utilities/Constants/constants.dart';
import '../../../api/sharedPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class PricesProv with ChangeNotifier {
  List<PricesModel> pricesObjects = [];

  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };


  Future<dynamic> deletePrice(int priceId,String userId) async {
    String data = '';

    try {
      http.Response response = await http.delete(
          Uri.parse('$BASE_URL/api/Guest/DeleteOwner?ID=$priceId&UserID=$userId'),
          headers: mHeaders);

      String responseBody = response.body;

      var decodedRes = jsonDecode(responseBody);

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


  Future<dynamic> addPrices(String type,double price,double priceInHoliday) async {
    String data = '';

    String body = jsonEncode({
        'type': type,
        'price': price,
        'priceInHoliday': priceInHoliday

    });

    try {
      http.Response response = await http.post(
          Uri.parse('$BASE_URL/api/Guest/AddOwner'),
          body: body,
          headers: mHeaders);

      String responseBody = response.body;
      debugPrint('response $responseBody');

      var decodedRes = jsonDecode(responseBody);

      debugPrint('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e);
    }
  }  Future<dynamic> updatePrices(int id,String type,double price,double priceInHoliday) async {
    String data = '';

    String body = jsonEncode({
        'id': id,
        'type': type,
        'price': price,
        'priceInHoliday': priceInHoliday

    });

    try {
      http.Response response = await http.put(
          Uri.parse('$BASE_URL/api/Guest/UpdateOwner'),
          body: body,
          headers: mHeaders);

      String responseBody = response.body;
      debugPrint('response $responseBody');

      var decodedRes = jsonDecode(responseBody);

      debugPrint('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e);
    }
  }



  Future<dynamic> getPrices() async {
    String data = '';

    try {
      http.Response response = await http
          .get(Uri.parse('$BASE_URL/api/Guest/GetOwners'), headers: mHeaders);
      debugPrint(' response is ${jsonDecode(response.body)['response']}');
      debugPrint(' message is ${jsonDecode(response.body)['message']}');

      if (jsonDecode(response.body)['message'] == 'Success') {
        data = 'Success';

        var pricesObj = jsonDecode(response.body)['response'] as List;

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
