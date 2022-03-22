import 'dart:convert';
import 'dart:io';
import 'package:clean_app/Data/Models/admin/publicHolidaysModel.dart';
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

class PublicHolidaysProv with ChangeNotifier {
  List<PublicHolidaysModel> holidaysList = [];
var startDate;
var endDate;


void changeDate(String start,String end){
  startDate=start;
  endDate=end;
  notifyListeners();
}
  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };


  Future<dynamic> deleteHoliday(int holidayId) async {
    String data = '';

    try {
      http.Response response = await http.delete(
          Uri.parse('$BASE_URL/api/Holiday/DeleteOfficialHoliday?ID=$holidayId'),
          headers: mHeaders);

      String responseBody = response.body;

      var decodedRes = jsonDecode(responseBody);

      debugPrint('response is $decodedRes');
      debugPrint('message is ${decodedRes['message']}');

      if (decodedRes['message'] == 'Success') {
        data = 'success';

        holidaysList.removeWhere((element) => element.id == holidayId);
      }

      notifyListeners();
      return data;
    } catch (e) {
      print(e);
    }
  }


  Future<dynamic> addPublicHolidays(String startDate,String endDate,String description) async {
    String data = '';

    String body = jsonEncode({
      'startDate': startDate,
      'endDate': endDate,
      'description': description

    });

    try {
      http.Response response = await http.post(
          Uri.parse('$BASE_URL/api/Holiday/AddOfficialHoliday'),
          body: body,
          headers: mHeaders);

      String responseBody = response.body;
      debugPrint('response $responseBody');

      var decodedRes = jsonDecode(responseBody);

      debugPrint('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        data = 'Success';
        getPublicHolidays();
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e);
    }
  }



  Future<dynamic> updatePublicHolidays(int id,String startDate,String endDate,String description) async {
    String data = '';

    String body = jsonEncode({
      'id': id,
      'startDate': startDate,
      'endDate': endDate,
      'description': description

    });

    try {
      http.Response response = await http.put(
          Uri.parse('$BASE_URL/api/Holiday/UpdateOfficialHoliday'),
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



  Future<dynamic> getPublicHolidays() async {
    String data = '';

    try {
      http.Response response = await http
          .get(Uri.parse('$BASE_URL/api/Holiday/GetOfficialHoliday'), headers: mHeaders);
      debugPrint(' response is ${jsonDecode(response.body)['response']}');
      debugPrint(' message is ${jsonDecode(response.body)['message']}');

      if (jsonDecode(response.body)['message'] == 'Success') {
        data = 'Success';

        var publicHolidaysObj = jsonDecode(response.body)['response'] as List;

        holidaysList =
            publicHolidaysObj.map((item) => PublicHolidaysModel.fromJson(item)).toList();

        holidaysList = holidaysList.reversed.toList();
        debugPrint('public holidays length is ${holidaysList.length}');
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e);
    }
  }
}
