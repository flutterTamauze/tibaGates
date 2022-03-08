import 'dart:convert';

import '../../Data/Models/admin/parking.dart';
import '../../Utilities/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class AdminProv with ChangeNotifier{

int carsCount;
double totalBalance;
List<ParkingModel> parkingList = [];



  Future<void> getParkingListForAdmin() async {
    print('token ${prefs.getString('token')}');
    Map<String, String> mHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}'
    };
    try {
      http.Response response = await http.get(
          Uri.parse('$BASE_URL/api/gate/parkedforadmin'),
          headers: mHeaders);

      print('statusCode ${response.statusCode}');
      print('response ${jsonDecode(response.body)['response']}');

      var parkJsonObj =
      jsonDecode(response.body)['response']['parkedDTO'] as List;
      print('parking response  $parkJsonObj');
      carsCount=jsonDecode(response.body)['response']['summaryDTO']['count'];
      totalBalance=jsonDecode(response.body)['response']['summaryDTO']['total_Fines'];
      parkingList =
          parkJsonObj.map((item) => ParkingModel.fromJson(item)).toList();
      parkingList = parkingList.reversed.toList();
      print('parking length  ${parkingList.length}');


      notifyListeners();
    } catch (e) {
      print(e);
    }
  }


}