import 'dart:convert';

import 'package:clean_app/api/base_client.dart';
import 'package:clean_app/api/base_exception_handling.dart';

import '../../Data/Models/admin/a_homeBio_model.dart';

import '../../Data/Models/admin/a_parking_model.dart';
import '../../Utilities/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class AdminHomeProv with ChangeNotifier, BaseExceptionHandling {
  int carsCount;
  double totalBalance;
  List<HomeBioModel> parkingList = [];
  List<String> parkTypes = [];

  Future<void> getBioData() async {
    try {
      var response = await BaseClient()
          .get(BASE_URL, '/api/gate/summaryforparked')
          .catchError(handleError);

      debugPrint('response ${jsonDecode(response)['response']}');

      var parkJsonObj =
          jsonDecode(response)['response']['parkTypeCountDTO'] as List;
      debugPrint('parking response  $parkJsonObj');
      carsCount = jsonDecode(response)['response']['summaryDTO']['count'];
      totalBalance = double.parse(jsonDecode(response)['response']['summaryDTO']
              ['total_Fines']
          .toString());
      parkingList =
          parkJsonObj.map((item) => HomeBioModel.fromJson(item)).toList();
      if (parkTypes.isEmpty) {
        parkTypes.add('الكل');
        for (int i = 0; i < parkingList.length; i++) {
          parkTypes.add(parkingList[i].type);
        }
      }

      parkingList = parkingList.reversed.toList();
      debugPrint('parking length  ${parkingList.length}');
      debugPrint('parking types length  ${parkTypes.length}');

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString() ?? '');
    }
  }
}
