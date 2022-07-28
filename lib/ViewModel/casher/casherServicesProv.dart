import 'dart:convert';
import '../../Data/Models/casher/services_model.dart';
import '../../Utilities/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../api/base_client.dart';
import '../../api/base_exception_handling.dart';
import '../../main.dart';

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
    String data = '';
    debugPrint('gate id $gateId');
    try {
      var response = await BaseClient()
          .get(prefs.getString('baseUrl'), '/api/Service/GetAllActive/$gateId')
          .catchError(handleError);

      var jsonObj = jsonDecode(response)['response'] as List;

      serviceObjects =
          jsonObj.map((item) => ServicesModel.fromJson(item)).toList();

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

  Future<dynamic> addBill(int serviceId, double total, int count, String userId,
      List<String> followersBarcode) async {
    String data = '';
    Map<String, dynamic> postedData;
    debugPrint('barcodes legnth ${followersBarcode.length}');

    try {
      postedData = {
        'barCodes': followersBarcode,
        'qty': count,
        'total': total,
        'serviceId': serviceId,
        'userId': userId
      };

      debugPrint('data is $postedData');

      var response = await BaseClient()
          .post(prefs.getString('baseUrl'), '/api/Service_Bill/Add', postedData)
          .catchError(handleError);

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
