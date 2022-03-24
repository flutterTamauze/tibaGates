import 'dart:convert';
import 'dart:io';
import 'package:clean_app/Data/Models/manager/invitationType_model.dart';
import 'package:clean_app/Data/Models/manager/invitation_model.dart';
import 'package:clean_app/Data/Models/admin/prices.dart';
import 'package:clean_app/Data/Models/admin/weeklyHolidays.dart';
import 'package:clean_app/api/base_client.dart';
import 'package:clean_app/api/base_exception_handling.dart';

import '../../../Utilities/Constants/constants.dart';
import '../../../api/sharedPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class HolidaysProv with ChangeNotifier,BaseExceptionHandling {
  List<WeeklyHolidaysModel> holidaysObjects = [];

  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };

  Future<dynamic> updateWeeklyHolidays(
      int id, String day, String isHoliday) async {
    String data = '';

    try {
      var response =
          await BaseClient().put(BASE_URL, '/api/Holiday/UpdateWeeklyHoliday', {
        'id': id,
        'day': day,
        'isHoliday': isHoliday.toString() == 'false' ? false : true
      }).catchError(handleError);

      var decodedRes = jsonDecode(response);

      debugPrint('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        data = 'Success';
        getWeeklyHolidays();
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e??'');
    }
  }

  Future<dynamic> getWeeklyHolidays() async {
    String data = '';

    try {
      var response = await BaseClient()
          .get(BASE_URL, '/api/Holiday/GetWeeklyHoliday')
          .catchError(handleError);


      debugPrint(' response is ${jsonDecode(response)['response']}');
      debugPrint(' message is ${jsonDecode(response)['message']}');

      if (jsonDecode(response)['message'] == 'Success') {
        data = 'Success';

        var holidaysObj = jsonDecode(response)['response'] as List;

        holidaysObjects = holidaysObj
            .map((item) => WeeklyHolidaysModel.fromJson(item))
            .toList();

        holidaysObjects = holidaysObjects.reversed.toList();
        debugPrint('holidays length is ${holidaysObjects.length}');
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e??'');
    }
  }
}
