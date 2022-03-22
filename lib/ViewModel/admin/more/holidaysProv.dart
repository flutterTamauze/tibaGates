import 'dart:convert';
import 'dart:io';
import 'package:clean_app/Data/Models/manager/invitationType_model.dart';
import 'package:clean_app/Data/Models/manager/invitation_model.dart';
import 'package:clean_app/Data/Models/admin/prices.dart';
import 'package:clean_app/Data/Models/admin/weeklyHolidays.dart';

import '../../../Utilities/Constants/constants.dart';
import '../../../api/sharedPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class HolidaysProv with ChangeNotifier {
  List<WeeklyHolidaysModel> holidaysObjects = [];




  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };

  Future<dynamic> updateWeeklyHolidays(int id, String day, String isHoliday) async {
    String data = '';

    String body =
        jsonEncode({'id': id, 'day': day, 'isHoliday': isHoliday.toString()=='false'?false:true});

    try {
      http.Response response = await http.put(
          Uri.parse('$BASE_URL/api/Holiday/UpdateWeeklyHoliday'),
          body: body,
          headers: mHeaders);

      String responseBody = response.body;
      debugPrint('response $responseBody');

      var decodedRes = jsonDecode(responseBody);

      debugPrint('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        data = 'Success';
        getWeeklyHolidays();

      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<dynamic> getWeeklyHolidays() async {
    String data = '';

    try {
      http.Response response = await http.get(
          Uri.parse('$BASE_URL/api/Holiday/GetWeeklyHoliday'),
          headers: mHeaders);
      debugPrint(' response is ${jsonDecode(response.body)['response']}');
      debugPrint(' message is ${jsonDecode(response.body)['message']}');

      if (jsonDecode(response.body)['message'] == 'Success') {
        data = 'Success';

        var holidaysObj = jsonDecode(response.body)['response'] as List;

        holidaysObjects = holidaysObj
            .map((item) => WeeklyHolidaysModel.fromJson(item))
            .toList();

        holidaysObjects = holidaysObjects.reversed.toList();
        debugPrint('holidays length is ${holidaysObjects.length}');
      }

      notifyListeners();
      return data;
    }

    catch (e) {
      debugPrint(e);
    }
  }
}
