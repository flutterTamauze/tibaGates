import 'dart:convert';
import 'dart:io';
import '../Utilities/Constants/constants.dart';
import '../api/sharedPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProv with ChangeNotifier {
  var guardId;

  String guardName;
  String token;
  String printerAddress;
  String gateName;
  double balance;
  double lostTicketPrice;

  bool isLogged;
  bool loadingState = false;

  void changeLoadingState(bool newValue) {
    loadingState = newValue;
    print('loading becomes $loadingState');
    notifyListeners();
  }

  Future<dynamic> login(
      String username, String password, File guardImage) async {
    String data = '';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    var uri = Uri.parse('$BASE_URL/api/user/LogIn');

    var request =  http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('file', guardImage.path),
    );


    request.fields['Password'] = password;
    request.fields['UserName'] = username;

    request.headers.addAll(headers);

    try {
      await request.send().then((response) async {

        print('rspnse $response');
        print('status code ${response.statusCode}');

        response.stream.transform(utf8.decoder).listen((value) async {

          Map<String, dynamic> responseDecoded = json.decode(value);

          print("response is ${responseDecoded['response']}");
          print('message is ${responseDecoded['message']}');

          if (responseDecoded['message'] == 'Success') {
            var userJson=responseDecoded['response']['user'];
            data = 'Success';
            guardId = userJson['id'];
            guardName = userJson['name'];
            token = userJson['token'];
            balance = double.parse(userJson['balance'].toString());
            printerAddress = userJson['printerMac'];
            gateName = userJson['gateName'];

            isLogged = true;
            lostTicketPrice = double.parse(responseDecoded['response']
                    ['printReasons'][0]['price']
                .toString());
          } else if (responseDecoded['message'] == 'Incorrect User') {
            data = 'Incorrect User';
          }
        });
      }).catchError((e) {
        if(e.toString().contains('SocketException: OS Error: No route to host')){
          data='you need to be at same network with local host';
        }

        print('catch error $e');
      });
    } catch (e) {
      print('error $e');
    }
    notifyListeners();
    return data;
  }
}
