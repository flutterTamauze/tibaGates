import 'dart:async';
import 'dart:convert';
import '../../Data/Models/manager/invitationType_model.dart';
import '../../Data/Models/manager/invitation_model.dart';
import '../../api/base_client.dart';
import '../../api/base_exception_handling.dart';
import '../../Utilities/Constants/constants.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class ManagerProv with ChangeNotifier, BaseExceptionHandling {
  List<InvitationTypesModel> invitationObjects = [];
  List<String> invitationTypes = [];
  List<Invitation> invitationsList = [];
  String qrCode;

  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };

  Future<dynamic> addInvitation(String visitorName, String visitorDescription,
      String managerId, int invitationTypeID, String fromDate, String toDate) async {
    String data = '';

    try {
      var response =
          await BaseClient().post(prefs.getString("baseUrl"), '/api/invitation/AddInvitation', {
        'Name': visitorName,
        'Description': visitorDescription,
        'GardUserId': managerId,
        'InvitationTypeID': invitationTypeID,
        'creationdate': fromDate,
        'expirydate': toDate,
      }).catchError(handleError);

      var decodedRes = jsonDecode(response);

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

  Future<dynamic> deleteInvitation(int invitationId, String userId) async {
    String data = '';

    try {
      var response = await BaseClient()
          .delete(prefs.getString("baseUrl"),
              '/api/invitation/DeleteInvitation?id=$invitationId&UserId=$userId')
          .catchError(handleError);

      var decodedRes = jsonDecode(response);

      debugPrint('response is $decodedRes');
      debugPrint('message is ${decodedRes['message']}');

      if (decodedRes['message'] == 'Success') {
        data = 'success';

        invitationsList.removeWhere((element) => element.id == invitationId);
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e);
    }
  }



  Future<dynamic> getInvitations(String userId, [String from]) async {
    String data = '';
    print('userId $userId   from $from');
    String endPoint = from == null
        ? '/api/invitation/getinvitations?UserId=$userId'
        : '/api/invitation/getinvitations?UserId=$userId&From=$from';
    print('endpoint $endPoint');
    try {
      var response =
          await BaseClient().get(prefs.getString("baseUrl"), endPoint).catchError(handleError);

      if (jsonDecode(response)['message'] == 'Success') {
        data = 'Success';
        var invitationObj =
            jsonDecode(response)['response']['invitations'] as List;

        var invitationTypesObj =
            jsonDecode(response)['response']['types'] as List;

        debugPrint('invitations response is $invitationObj');
        debugPrint('invitations types response is $invitationTypesObj');

        invitationObjects = invitationTypesObj
            .map((item) => InvitationTypesModel.fromJson(item))
            .toList();

        for (int i = 0; i < invitationObjects.length; i++) {
          debugPrint(invitationObjects[i].invitationType);
          if (!invitationTypes.contains(invitationObjects[i].invitationType)) {
            invitationTypes.add(invitationObjects[i].invitationType);
          }
        }

        invitationsList =
            invitationObj.map((item) => Invitation.fromJson(item)).toList();

        invitationsList = invitationsList.reversed.toList();

        debugPrint('invitations length  ${invitationsList.length}');
        debugPrint('invitationTypes length  ${invitationTypes.length}');
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e.toString() ?? '');
    }
  }
}

class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}
