import 'dart:io';
import 'package:clean_app/Data/Models/guard/parked_model.dart';
import 'package:clean_app/Data/Models/guard/reasons_model.dart';
import 'package:clean_app/Data/Models/guard/visitorTypes_model.dart';
import 'package:clean_app/Data/Models/response.dart';
import 'package:clean_app/Utilities/Constants/constants.dart';
import 'package:clean_app/ViewModel/guard/authProv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class VisitorProv with ChangeNotifier {

  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };


  List<File> images = [];
  List<ReasonModel> reasonsObjects = [];
  List<String> reasons = [];
  File rokhsa;
  File idCard;
  bool isVIP;
  int invitationID;
  var totalPrice, militaryPrice, citizenPrice, parkPrice, qrCode, printTime;
  var logId;
  List<ParkingCarsModel> parkingList = [];

  List<VisitorTypesModel> visitorObjects = [];
  List<String> visitorTypes = [];

  void addIdCard(File image) {
    idCard = image;
    notifyListeners();
  }

  void addRokhsa(File image) {
    rokhsa = image;
    notifyListeners();
  }

  void deleteRokhsa() {
    rokhsa = null;
    notifyListeners();
  }

  void deleteId() {
    idCard = null;
    notifyListeners();
  }

  void addImageToItem(File image) {
    images.add(image);
    notifyListeners();
  }

  void deleteImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  Future<dynamic> getVisitorTypes() async {
    try {
      if (visitorObjects.isNotEmpty) {
        print('visitorObjects not null');
        return;
      } else {
        print('visitorObjects null');

        var response = await http
            .get(Uri.parse('$BASE_URL/api/guest/getOwners'), headers: mHeaders);

        print('status code ${response.statusCode}');

        var jsonObj = jsonDecode(response.body)['response'] as List;
        print('the response $jsonObj');

        visitorObjects =
            jsonObj.map((item) => VisitorTypesModel.fromJson(item)).toList();

        for (int i = 0; i < visitorObjects.length; i++) {
          print(visitorObjects[i].visitorType);
          if (!visitorTypes.contains(visitorObjects[i].visitorType)) {
            visitorTypes.add(visitorObjects[i].visitorType);
          }
        }

        print('length of visitor types ${visitorTypes[0]}');

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getParkingList() async {
    try {
      http.Response response = await http
          .get(Uri.parse('$BASE_URL/api/gate/parked'), headers: mHeaders);

      var parkJsonObj =
          jsonDecode(response.body)['response']['parkedDTO'] as List;
      var reasonsJsonObj =
          jsonDecode(response.body)['response']['reasonDTO'] as List;

      print('parking response  $parkJsonObj');
      print('reasons response  $reasonsJsonObj');

      parkingList =
          parkJsonObj.map((item) => ParkingCarsModel.fromJson(item)).toList();
      reasonsObjects =
          reasonsJsonObj.map((item) => ReasonModel.fromJson(item)).toList();

      for (int i = 0; i < reasonsObjects.length; i++) {
        print(reasonsObjects[i].reason);
        if (!reasons.contains(reasonsObjects[i].reason)) {
          reasons.add(reasonsObjects[i].reason);
        }
      }

      parkingList = parkingList.reversed.toList();

      print('parking length  ${parkingList.length}');
      print('reasons length  ${reasons.length}');

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<ResponseData> checkIn(
      File carImg,
      File identityImg,
      String userID,
      int typeID,
      int citizenCount,
      int militaryCount,
      BuildContext context) async {
    ResponseData responseData = ResponseData();
    print('userID $userID');




    var uri = Uri.parse('$BASE_URL/api/gate/CheckIn');

    var request =  http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('file', carImg.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath('file1', identityImg.path),
    );

    request.fields['UserID'] = userID.toString();
    request.fields['TypeID'] = typeID.toString();
    request.fields['militryCount'] = militaryCount.toString();
    request.fields['civilCount'] = citizenCount.toString();

    request.headers.addAll(mHeaders);

    try {
      await request.send().then((response) async {
        print('status code ${response.statusCode}');
        if(response.statusCode==401){
          responseData.message = 'unAuth';
        }
        response.stream.transform(utf8.decoder).listen((value) {
          Map<String, dynamic> responseDecoded = json.decode(value);
          print("ah ah ${responseDecoded['response']}");

          print('message is ${responseDecoded['message']}');
          if (responseDecoded['message'] == 'Success') {
            responseData.message = 'Success';
            qrCode = responseDecoded['response']['qrCode'];
            printTime = responseDecoded['response']['printTime'];
            logId = responseDecoded['response']['id'];
          }
        });
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return responseData;
  }

  Future<ResponseData> checkInInvitation(
    String userID,
    int invitationID,
    BuildContext context, [
    File carImg,
    File identityImg,
  ]) async {
    ResponseData responseData = ResponseData();
    print('userID $userID');

    var uri = Uri.parse('$BASE_URL/api/invitation/CheckInInvitation');
    var request =  http.MultipartRequest('POST', uri);

    if (carImg != null && identityImg != null) {
      print('images not null');
      request.files.add(
        await http.MultipartFile.fromPath('file', carImg.path),
      );
      request.files.add(
        await http.MultipartFile.fromPath('file1', identityImg.path),
      );
    }

    request.fields['UserID'] = userID.toString();
    request.fields['invitationID'] = invitationID.toString();

    request.headers.addAll(mHeaders);

    try {
      await request.send().then((response) async {
        print(response.statusCode);
        response.stream.transform(utf8.decoder).listen((value) {
          Map<String, dynamic> responseDecoded = json.decode(value);
          print("ah ah ${responseDecoded['response']}");

          print('message is ${responseDecoded['message']}');
          if (responseDecoded['message'] == 'Success') {
            responseData.message = 'Success';
            qrCode = responseDecoded['response']['qrCode'];
            printTime = responseDecoded['response']['printTime'];
            logId = responseDecoded['response']['id'];
          }
        });
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return responseData;
  }

  Future<dynamic> getBill(
      String typeID, String citizenCount, String militaryCount) async {
    print('type id $typeID');
    String data = '';

    String body = jsonEncode({
      'TypeID': typeID,
      'militryCount': militaryCount,
      'civilCount': citizenCount
    });

    try {
      http.Response response = await http.post(
          Uri.parse('$BASE_URL/api/gate/bill'),
          body: body,
          headers: mHeaders);

      String responseBody = response.body;
      print('response $responseBody');

      var decodedRes = jsonDecode(responseBody);

      print('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        totalPrice = decodedRes['response']['total'];
        parkPrice = decodedRes['response']['price'];
        citizenPrice = decodedRes['response']['civilPrice'];
        militaryPrice = decodedRes['response']['militryPrice'];
        logId = decodedRes['response']['id'];

        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getLogById(int logId) async {
    String data = '';

    try {
      http.Response response = await http.post(
          Uri.parse('$BASE_URL/api/gate/GetLogByID/$logId'),
          headers: mHeaders);

      String responseBody = response.body;
      print('response $responseBody');

      var decodedRes = jsonDecode(responseBody);

      print('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        qrCode = decodedRes['response']['qrCode'];
        printTime = decodedRes['response']['printTime'];
        totalPrice = decodedRes['response']['total'];
        parkPrice = decodedRes['response']['price'];
        citizenPrice = decodedRes['response']['civilPrice'];
        militaryPrice = decodedRes['response']['militryPrice'];

        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> confirmPrint(String userId, int logId, int reasonId) async {
    String data = '';
    print('logId $logId  userId $userId  reasonId $reasonId');

    try {
      http.Response response = await http.post(
          Uri.parse(
              '$BASE_URL/api/gate/print?UserID=$userId&LogID=$logId&ReasonID=$reasonId'),
          headers: mHeaders);

      String responseBody = response.body;
      print('response $responseBody');

      var decodedRes = jsonDecode(responseBody);

      print('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        print(decodedRes['response']);
        printTime = decodedRes['response']['printTime'];
        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> cancel(int logId) async {
    String data = '';

    try {
      http.Response response = await http.delete(
          Uri.parse('$BASE_URL/api/gate/Cancel/$logId'),
          headers: mHeaders);

      String responseBody = response.body;
      var decodedRes = jsonDecode(responseBody);
      print('response is $decodedRes');
      if (decodedRes['message'] == 'Success') {
        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> checkOut(String qrCode) async {
    String data = '';
    print('qrCode $qrCode');

    try {
      var uri = Uri.parse('$BASE_URL/api/gate/CheckOut');
      var request = new http.MultipartRequest('PUT', uri);
      print('1*');
      request.fields['QrCode'] = qrCode;
      request.headers.addAll(mHeaders);
      print('2*');
      try {
        await request.send().then((response) async {
          print(' status code is ${response.statusCode}');
          print('3*');
          response.stream.transform(utf8.decoder).listen((value) {
            print('4*');
            Map<String, dynamic> responseDecoded = json.decode(value);
            print('5*');
            print("ah ah ${responseDecoded['response']}");

            print('message is $responseDecoded');

            if (responseDecoded['message'] == 'Success') {
              data = 'Success';
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
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> checkOutInvitation(String qrCode) async {
    String data = '';
    print('qrCode $qrCode');

    try {
      var uri = Uri.parse('$BASE_URL/api/Invitation/ScanInvitationQr');
      var request =  http.MultipartRequest('POST', uri);

      request.fields['QrCode'] = qrCode;
      request.headers.addAll(mHeaders);

      try {
        await request.send().then((response) async {
          print(' status code is ${response.statusCode}');

          response.stream.transform(utf8.decoder).listen((value) {
            Map<String, dynamic> responseDecoded = json.decode(value);
            print("response ${responseDecoded['response']}");
            invitationID = responseDecoded['response']['id'];
            isVIP = responseDecoded['response']['isVIP'];

            print('message is $responseDecoded');

            if (isVIP) {
              data = 'vip';
            } else if (responseDecoded['message'] == 'Success') {
              data = 'Success';
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
    } catch (e) {
      print(e);
    }
  }
}
