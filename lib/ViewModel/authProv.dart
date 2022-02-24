import 'dart:convert';
import 'dart:io';
import 'package:clean_app/Core/Constants/constants.dart';
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
  double lostTicketPrice;
  String rank;
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

    var request = new http.MultipartRequest("POST", uri);
    request.files.add(
      await http.MultipartFile.fromPath("file", guardImage.path),
    );

    request.fields['Password'] = password;
    request.fields['UserName'] = username;

    request.headers.addAll(headers);

    try {
      await request.send().then((response) async {
        print(response.statusCode);
        response.stream.transform(utf8.decoder).listen((value) {
          Map<String, dynamic> responseDecoded = json.decode(value);
          print("ah ah ${responseDecoded['response']}");

          print('message is ${responseDecoded['message']}');
          if (responseDecoded['message'] == 'Success') {
            data = 'Success';
            guardId = responseDecoded['response']['user']['id'];
            guardName = responseDecoded['response']['user']['name'];
            balance = double.parse(
                responseDecoded['response']['user']['balance'].toString());
            printerAddress = responseDecoded['response']['user']['printerMac'];
            gateName = responseDecoded['response']['user']['gateName'];
            gateId = responseDecoded['response']['user']['gateID'];
            rank = responseDecoded['response']['user']['rank'];
            isLogged = true;
            lostTicketPrice = double.parse(responseDecoded['response']
                    ['printReasons'][0]['price']
                .toString());
            //print('ticket price $lostTicketPrice');
          } else if (responseDecoded['message'] == 'Incorrect User') {
            data = 'Incorrect User';
          }
        });
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return data;
  }
}
