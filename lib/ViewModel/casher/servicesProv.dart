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
   // notifyListeners();
  }

  Future<dynamic> getServices() async {
    try {
      if (serviceObjects.isNotEmpty) {
        print('service Objects not null');
        return;
      } else {
        print('service Objects null');

        var response = await BaseClient()
            .get(BASE_URL, '/api/Service/GetAllActive')
            .catchError(handleError);

        var jsonObj = jsonDecode(response)['response'] as List;

        serviceObjects =
            jsonObj.map((item) => ServicesModel.fromJson(item)).toList();
        servicePrice = serviceObjects[0].servicePrice;
        for (int i = 0; i < serviceObjects.length; i++) {
          debugPrint(serviceObjects[i].serviceName);
          if (!serviceTypes.contains(serviceObjects[i].serviceName)) {
            serviceTypes.add(serviceObjects[i].serviceName);
          }
        }

        debugPrint('length of services types ${serviceTypes[0]}');

        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future<dynamic> addBill(int serviceId,double total,int count) async {

    String data = '';

    try {
      var response = await BaseClient().post(BASE_URL, '/api/Service_Bill/Add',{
        'qty': count,
        'total': total,
        'serviceId': serviceId
      }).catchError(handleError);

      String responseBody = response;

      var decodedRes = jsonDecode(responseBody);

      if (decodedRes['message'] == 'Success') {

        data = 'Success';
        printTime=decodedRes['response']['billDate'];
        billId=decodedRes['response']['id'];
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }


}
