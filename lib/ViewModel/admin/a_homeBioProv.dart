import 'dart:convert';

import '../../Data/Models/admin/a_homeBio_model.dart';

import '../../Data/Models/admin/a_parking_model.dart';
import '../../Utilities/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class AdminHomeProv with ChangeNotifier {
  int carsCount;
  double totalBalance;
  List<HomeBioModel> parkingList = [];
  List<String> parkTypes = [];

  Future<void> getBioData() async {

    Map<String, String> mHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}'
    };

    try {
      http.Response response = await http.get(
          Uri.parse('$BASE_URL/api/gate/summaryforparked'),
          headers: mHeaders);

      print('statusCode ${response.statusCode}');
      print('response ${jsonDecode(response.body)['response']}');

      var parkJsonObj =
          jsonDecode(response.body)['response']['parkTypeCountDTO'] as List;
      print('parking response  $parkJsonObj');
      carsCount = jsonDecode(response.body)['response']['summaryDTO']['count'];
      totalBalance = double.parse(jsonDecode(response.body)['response']
              ['summaryDTO']['total_Fines']
          .toString());
      parkingList =
          parkJsonObj.map((item) => HomeBioModel.fromJson(item)).toList();
      if(parkTypes.isEmpty){
        parkTypes.add('الكل');
        for(int i=0;i<parkingList.length;i++){
          parkTypes.add(parkingList[i].type);
        }
      }

      parkingList = parkingList.reversed.toList();
      print('parking length  ${parkingList.length}');
      print('parking types length  ${parkTypes.length}');

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }


}
