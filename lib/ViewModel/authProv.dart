import 'dart:convert';
import 'dart:io';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Data/Models/reasons_model.dart';
import 'package:clean_app/Data/Models/visitorTypes_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class AuthProv with ChangeNotifier {
  var guardId;
  var gateId;
  String guardName;
  String printerAddress;
  String gateName;
  double balance;
  String rank;
  bool isLogged;
  bool loadingState = false;
/*  List<ReasonModel> reasonsObjects = [];
  List<String> reasons = [];

  List<VisitorTypesModel> visitorObjects = [];
  List<String> visitorTypes = [];*/

  void changeLoadingState(bool newValue) {
    loadingState = newValue;
    print('loading becomes $loadingState');
    notifyListeners();
  }

  Future<dynamic> login(String username, String password) async {
    String data = '';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    String body = jsonEncode({'Password': password, 'UserName': username});
    http.Response response;

    try {
      response = await http
          .post(Uri.parse('$BASE_URL/api/gate/LogIn'),
              body: body, headers: headers)
          .timeout(Duration(seconds: 4), onTimeout: () {
        print('status code is ${response.statusCode}');
        Fluttertoast.showToast(
            msg: 'تأكد من إتصالك بالإنترنت وحاول مجدداً',
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white);

        return http.Response(
            'internal server error', 500); // Replace 500 with your http code.
      });

      print('response.statusCode ${response.statusCode}');

      String responseBody = response.body;
      print('response  $responseBody');
      var decodedRes = jsonDecode(responseBody);
      print('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {


        data = 'Success';

        guardId = decodedRes['response']['id'];
        guardName = decodedRes['response']['name'];
        balance =   double.parse(decodedRes['response']['balance'].toString());
        printerAddress = decodedRes['response']['printerMac'];
        gateName = decodedRes['response']['gateName'];
        gateId = decodedRes['response']['gateID'];
        rank = decodedRes['response']['rank'];
        isLogged = true;

    /*    var reasonObj = jsonDecode(response.body)['response']['reasonDTO'] as List;
        var visitorTypeObj = jsonDecode(response.body)['response']['ownerDTO'] as List;

        reasonsObjects =
            reasonObj.map((item) => ReasonModel.fromJson(item)).toList();

        visitorObjects =
            visitorTypeObj.map((item) => VisitorTypesModel.fromJson(item)).toList();

        for (int i = 0; i < reasonsObjects.length; i++) {
          if (!reasons.contains(reasonsObjects[i].reason)) {
            reasons.add(reasonsObjects[i].reason);
          }
        }
        for (int i = 0; i < visitorObjects.length; i++) {
          if (!visitorTypes.contains(visitorObjects[i].visitorType)) {
            visitorTypes.add(visitorObjects[i].visitorType);
          }
        }

        print('length of reasons ${reasonsObjects.length}');
        print('length of visitorTypes ${visitorObjects.length}');*/


      } else if (decodedRes['message'] == 'Incorrect User') {
        data = 'Incorrect User';
      }

      notifyListeners();
      return data;
    } catch (e) {
      print(e);
    }
  }
}
