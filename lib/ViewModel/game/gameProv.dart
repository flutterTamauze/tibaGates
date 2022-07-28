import 'dart:convert';



import '../../Data/Models/admin/a_parking_model.dart';
import '../../Utilities/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api/base_client.dart';
import '../../api/base_exception_handling.dart';
import '../../main.dart';

class GameProv with ChangeNotifier, BaseExceptionHandling{



  Future<dynamic> submitGame(int id,int gameId) async {

    String data = '';
    debugPrint('gameId $gameId   id $id');

    try {
      var response = await BaseClient().post(prefs.getString("baseUrl"), '/api/GameLog/AddGameLog?id=$id&gameId=$gameId').catchError(handleError);
      debugPrint('1');
      String responseBody = response;
      debugPrint('2 $responseBody');
      var decodedRes = jsonDecode(responseBody);
      debugPrint('response is ${decodedRes['response']}');

      if (decodedRes['message'] == 'Success') {

        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }




}