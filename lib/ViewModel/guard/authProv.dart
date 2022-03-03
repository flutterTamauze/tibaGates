import 'dart:convert';
import 'dart:io';
import '../../Utilities/Constants/constants.dart';
import '../../api/sharedPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProv with ChangeNotifier {
  var userId;

  String guardName;
  String userRole;
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



  Future<dynamic> logout(String userID) async {
    String data = '';


    try {
      http.Response response = await http.post(
          Uri.parse('$BASE_URL/api/User/SignOut?UserId=$userId'),

      );

      String responseBody = response.body;
      print('response $responseBody');

      var decodedRes = jsonDecode(responseBody);

      print('response is $decodedRes');

      if (decodedRes['message'] == 'success') {
        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      print(e);
    }
  }











  Future<dynamic> login(
      String username, String password, File guardImage,String tabAddress) async {
    String data = '';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    var uri = Uri.parse('$BASE_URL/api/user/LogIn');

    var request =  http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('file', guardImage.path),
    );
print('1');

    request.fields['Password'] = password;
    request.fields['UserName'] = username;
    request.fields['PhoneMac'] = tabAddress;

    request.headers.addAll(headers);
    print('2');
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
            userRole  =responseDecoded['response']['roles'][0];
            data = 'Success';
            isLogged = true;
            userId = userJson['id'];
            token = userJson['token'];

            if(userRole !='Manager'){

              guardName = userJson['name'];
              balance = double.parse(userJson['balance'].toString());
              printerAddress = userJson['printerMac'];
              lostTicketPrice = double.parse(responseDecoded['response']
              ['printReasons'][0]['price']
                  .toString());
              gateName = userJson['gateName'];
            }


          } else if (responseDecoded['message'] == 'Incorrect User') {
            data = 'Incorrect User';
          }
          else{
            data=responseDecoded['message'];
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
