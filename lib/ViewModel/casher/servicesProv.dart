import 'dart:convert';

import '../../Data/Models/casher/services_model.dart';

import '../../Utilities/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/base_client.dart';
import '../../api/base_exception_handling.dart';

class ServicesProv with ChangeNotifier, BaseExceptionHandling {
  List<ServicesModel> serviceObjects = [];
  List<String> serviceTypes = [];
  List<String> engServiceTypes = [];
  String printTime;
  double servicePrice = 0;
  int billId;

  void calcPrice(int number, double selectedServicePrice) {
    debugPrint('number is $number   price  $selectedServicePrice');
    servicePrice = number * selectedServicePrice;
    notifyListeners();
  }

  void resetPrice() {
    servicePrice = serviceObjects[0].servicePrice;
  }

  Future<dynamic> getServices(int gateId) async {
    String data='';
    print('gate id $gateId');
    try {
      var response = await BaseClient()
          .get(BASE_URL, '/api/Service/GetAllActive/$gateId')
          .catchError(handleError);

      var jsonObj = jsonDecode(response)['response'] as List;

      serviceObjects =
          jsonObj.map((item) => ServicesModel.fromJson(item)).toList();

  /*    serviceObjects=[
        ServicesModel(id: 1,arServiceName: 'رضوان',serviceName: 'radwan',servicePrice: 20),
        ServicesModel(id: 1,arServiceName: 'رضوان',serviceName: 'radwan',servicePrice: 20),
        ServicesModel(id: 1,arServiceName: 'رضوان',serviceName: 'radwan',servicePrice: 20),
      ];
*/

      servicePrice = serviceObjects[0].servicePrice;

      for (int i = 0; i < serviceObjects.length; i++) {

        if (!serviceTypes.contains(serviceObjects[i].arServiceName)) {
          serviceTypes.add(serviceObjects[i].arServiceName);
        }


        if (!engServiceTypes.contains(serviceObjects[i].serviceName)) {
          engServiceTypes.add(serviceObjects[i].serviceName);
        }


      }

      debugPrint('length of services types ${serviceTypes[0]}');

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> addBill(
      int serviceId, double total, int count, String userId) async {
    String data = '';

    try {
      var response = await BaseClient().post(
          BASE_URL, '/api/Service_Bill/Add', {
        'qty': count,
        'total': total,
        'serviceId': serviceId,
        'userId': userId
      }).catchError(handleError);

      String responseBody = response;

      var decodedRes = jsonDecode(responseBody);

      if (decodedRes['message'] == 'Success') {
        data = 'Success';
        printTime = decodedRes['response']['billDate'];
        billId = decodedRes['response']['id'];
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
