import 'dart:convert';
import 'dart:io';
import '../../api/base_client.dart';
import '../../api/base_exception_handling.dart';

import '../../Utilities/Constants/constants.dart';
import '../../api/sharedPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProv with ChangeNotifier, BaseExceptionHandling {
  var userId;

  String guardName;
  String userRole;
  String token;
  String printerAddress;
  String gateName;
  int gateId;
  double balance;
  double lostTicketPrice;
  List<String> parkTypes;
  bool isLogged;
  bool loadingState = false;

  void changeLoadingState(bool newValue) {
    loadingState = newValue;
    debugPrint('loading becomes $loadingState');
    notifyListeners();
  }

  Future<dynamic> logout(String userID) async {
    String data = '';
    try {
      var response = await BaseClient()
          .post(
            BASE_URL,
            '/api/User/SignOut?UserId=$userId',
          )
          .catchError(handleError);

      debugPrint('response is $response');

      var decodedRes = jsonDecode(response);

      debugPrint('response is $decodedRes');

      if (decodedRes['message'] == 'success') {
        data = 'Success';
      }
      if (decodedRes['message'] == 'incorrect user') {
        data = 'incorrect user';
      }
      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('ex is $e');
    }
  }

  Future<dynamic> getBalanceById(String userID, String role) async {
    debugPrint('user id $userID');
    String data = '';

    try {
      var response = await BaseClient()
          .get(
            BASE_URL,
            '/api/Gate/GetUnPayedBills?UserID=$userId',
          )
          .catchError(handleError);

      String responseBody = response;

      var decodedRes = jsonDecode(responseBody);
print(decodedRes['status']);
      if (decodedRes['status'] == true) {

        if (role == 'Casher') {
          print('solidawy');
          balance = double.parse(decodedRes['response']['balance'].toString());
        }
        if (role == 'Guard') {
          balance = double.parse(
              decodedRes['response']['summaryDTO']['total'].toString());
        }

        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> login(String username, String password, File guardImage,
      String tabAddress) async {
    parkTypes = [];
    String data = '';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Uri uri = Uri.parse('$BASE_URL/api/user/LogIn');

    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('file', guardImage.path),
    );
    request.fields['Password'] = password;
    request.fields['UserName'] = username;
    request.fields['PhoneMac'] = tabAddress;
    request.fields['PhoneMac'] = tabAddress;

    request.headers.addAll(headers);
    try {
      await request.send().then((response) async {
        changeLoadingState(false);
        debugPrint('status code ${response.statusCode}');

        response.stream.transform(utf8.decoder).listen((value) async {
          Map<String, dynamic> responseDecoded = json.decode(value);

          debugPrint("response is ${responseDecoded['response']}");
          debugPrint('message is ${responseDecoded['message']}');

          if (responseDecoded['message'] == 'Success') {
            debugPrint('success case');
            data = 'Success';
            var userJson = responseDecoded['response']['user'];

            userRole = responseDecoded['response']['roles'][0];

            var reasonsJsonObj =
                responseDecoded['response']['parkTypes'] as List;

            if (parkTypes.isEmpty) {
              parkTypes.add('الكل');
              reasonsJsonObj.map((e) => parkTypes.add(e)).toList();
              debugPrint(parkTypes.length.toString());
            }

            isLogged = true;
            userId = userJson['id'];
            token = userJson['token'];

            if (userRole != 'Manager' && userRole != 'Admin') {
              guardName = userJson['name'] ?? '  -  ';
              // balance = double.parse(userJson['balance'].toString());
              printerAddress = userJson['printerMac'];
              lostTicketPrice = double.parse(responseDecoded['response']
                      ['printReasons'][0]['price']
                  .toString());
              gateName = responseDecoded['response']['gateName'] ?? '  -  ';
              gateId = responseDecoded['response']['user']['gateID'] ?? 0;
            }
          } else if (responseDecoded['message'] == 'Incorrect User') {
            data = 'Incorrect User';
          } else if (responseDecoded['message'] ==
              'failure during signning in') {
            data = 'Incorrect Password';
          } else {
            debugPrint('else case');
            data = responseDecoded['message'];
          }
        });
      });
    } catch (e) {
      debugPrint('error $e');
    }
    notifyListeners();
    debugPrint('data is $data');
    return data;
  }
}
