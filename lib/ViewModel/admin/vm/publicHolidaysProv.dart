import 'dart:convert';
import 'dart:io';
import 'package:clean_app/Data/Models/admin/publicHolidaysModel.dart';
import 'package:clean_app/Data/Models/manager/invitationType_model.dart';
import 'package:clean_app/Data/Models/manager/invitation_model.dart';
import 'package:clean_app/Data/Models/admin/prices.dart';
import 'package:clean_app/Data/Models/response.dart';
import 'package:clean_app/ViewModel/admin/Repos_Impl/publicHolidaysRepoImpl.dart';
import 'package:clean_app/ViewModel/manager/managerProv.dart';
import 'package:dartz/dartz.dart';

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

  void changeDate(String start, String end) {
    startDate = start;
    endDate = end;
    notifyListeners();
  }

  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };

  Future<dynamic> deleteHoliday(int holidayId) async {
    String data = '';
    var jsonResponse = await PublicHolidaysRepoImpl().deleteHoliday(holidayId);

    debugPrint(' message is ${jsonDecode(jsonResponse)['message']}');
    if (jsonDecode(jsonResponse)['message'] == 'Success') {
      data = 'success';
      holidaysList.removeWhere((element) => element.id == holidayId);
    }
    notifyListeners();
    return data;
  }

  Future<dynamic> addPublicHolidays(
      String startDate, String endDate, String description) async {
    String data = '';
    var jsonResponse = await PublicHolidaysRepoImpl()
        .addPublicHolidays(startDate, endDate, description);

    debugPrint(' message is ${jsonDecode(jsonResponse)['message']}');
    if (jsonDecode(jsonResponse)['message'] == 'Success') {
      data = 'Success';
      getPublicHolidays();
    }
    notifyListeners();
    return data;
  }

  Future<dynamic> updatePublicHolidays(
      int id, String startDate, String endDate, String description) async {
    String data = '';

    var jsonResponse = await PublicHolidaysRepoImpl()
        .updatePublicHolidays(id, startDate, endDate, description);
    debugPrint(' message is ${jsonDecode(jsonResponse)['message']}');
    if (jsonDecode(jsonResponse)['message'] == 'Success') {
      data = 'Success';
    }
    notifyListeners();
    return data;
  }

/*  Future<dynamic> getPublicHolidays() async {
    ResponseData responseData =
        await PublicHolidaysRepoImpl().getPublicHolidays();
    holidaysList = responseData.data;
    notifyListeners();
    return responseData.message;
  }*/

  Future<dynamic> getPublicHolidays() async {
    ResponseData responseData;
    var resp = await PublicHolidaysRepoImpl().getPublicHolidays();
    resp.fold((l) {
      print('aa $l');
    }, (r) {
      responseData = r;
    });
    holidaysList = responseData.data;
    notifyListeners();
    return responseData.message;
  }
}
