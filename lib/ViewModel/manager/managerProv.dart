import 'dart:convert';
import 'dart:io';
import 'package:clean_app/Data/Models/manager/invitationType_model.dart';

import '../../Utilities/Constants/constants.dart';
import '../../api/sharedPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class ManagerProv with ChangeNotifier {
  List<InvitationTypesModel> invitationObjects = [];
  List<String> invitationTypes = [];
  String qrCode;
  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };

  Future<dynamic> addInvitation(String visitorName, String visitorDescription, String managerId,int invitationTypeID ) async {
    String data = '';

    String body = jsonEncode({
      'Name': visitorName,
      'Description': visitorDescription,
      'GardUserId': managerId,
      'InvitationTypeID': invitationTypeID,
    });


    try {
      http.Response response = await http.post(
          Uri.parse('$BASE_URL/api/invitation/AddInvitation'),
          body: body,
          headers: mHeaders);

      String responseBody = response.body;
      print('response $responseBody');

      var decodedRes = jsonDecode(responseBody);

      print('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        qrCode = decodedRes['response']['qrCode'];
        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      print(e);
    }
  }


  Future<dynamic> getInvitationTypes() async {
    try {
      if (invitationObjects.isNotEmpty) {
        print('invitationObjects not null');
        return;
      } else {
        print('invitationObjects null');

        var response = await http
            .get(Uri.parse('$BASE_URL/api/invitation/getinvitationtypes'), headers: mHeaders);

        print('status code ${response.statusCode}');

        var jsonObj = jsonDecode(response.body)['response'] as List;
        print('the response $jsonObj');

        invitationObjects =
            jsonObj.map((item) => InvitationTypesModel.fromJson(item)).toList();

        for (int i = 0; i < invitationObjects.length; i++) {
          print(invitationObjects[i].invitationType);
          if (!invitationTypes.contains(invitationObjects[i].invitationType)) {
            invitationTypes.add(invitationObjects[i].invitationType);
          }
        }

        print('length of invitation types ${invitationObjects[0]}');

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
