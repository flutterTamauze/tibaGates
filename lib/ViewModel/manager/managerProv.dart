import 'dart:convert';
import 'dart:io';
import 'package:clean_app/Data/Models/manager/invitationType_model.dart';
import 'package:clean_app/Data/Models/manager/invitation_model.dart';

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
  List<Invitation> invitationsList = [];
  String qrCode;
  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };

  Future<dynamic> addInvitation(String visitorName, String visitorDescription,
      String managerId, int invitationTypeID,String date) async {
    String data = '';

    String body = jsonEncode({
      'Name': visitorName,
      'Description': visitorDescription,
      'GardUserId': managerId,
      'InvitationTypeID': invitationTypeID,
      'date': date,
    });

    try {
      http.Response response = await http.post(
          Uri.parse('$BASE_URL/api/invitation/AddInvitation'),
          body: body,headers: mHeaders
        );

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

/*  Future<dynamic> getInvitationTypes() async {
    try {
      if (invitationObjects.isNotEmpty) {
        print('invitationObjects not null');
        return;
      } else {
        print('invitationObjects null');

        var response = await http.get(
            Uri.parse('$BASE_URL/api/invitation/getinvitationtypes'),
            headers: mHeaders);

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
  }*/

  Future<dynamic> getInvitations(String userId, [String from]) async {
    String data='';
    print('userId $userId');
    String url = from == null
        ? '$BASE_URL/api/invitation/getinvitations?UserId=$userId'
        : '$BASE_URL/api/invitation/getinvitations?UserId=$userId&From=$from';
    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: mHeaders);
if(jsonDecode(response.body)['message']=='Success'){
  data='Success';
  var invitationObj =
  jsonDecode(response.body)['response']['invitations'] as List;

  var invitationTypesObj =
  jsonDecode(response.body)['response']['types'] as List;

  print(' response is ${jsonDecode(response.body)['response']}');
  print('invitations response is $invitationObj');
  print('invitations types response is $invitationTypesObj');

  invitationObjects = invitationTypesObj
      .map((item) => InvitationTypesModel.fromJson(item))
      .toList();

  for (int i = 0; i < invitationObjects.length; i++) {
    print(invitationObjects[i].invitationType);
    if (!invitationTypes.contains(invitationObjects[i].invitationType)) {
      invitationTypes.add(invitationObjects[i].invitationType);
    }
  }

  invitationsList =
      invitationObj.map((item) => Invitation.fromJson(item)).toList();

  invitationsList = invitationsList.reversed.toList();

  print('invitations length  ${invitationsList.length}');
}



      notifyListeners();
return data;
    } catch (e) {
      print(e);
    }
  }
}
