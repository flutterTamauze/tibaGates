import 'dart:developer';
import 'dart:io';
import '../../Data/Models/guard/memberChip_model.dart';

import '../../Data/Models/guard/perHour.dart';
import 'package:dartz/dartz.dart';

import '../../api/base_client.dart';
import '../../api/base_exception_handling.dart';

import '../../Data/Models/guard/parked_model.dart';
import '../../Data/Models/guard/reasons_model.dart';
import '../../Data/Models/guard/visitorTypes_model.dart';
import '../../Data/Models/response.dart';
import '../../Utilities/Constants/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../main.dart';

class VisitorProv with ChangeNotifier, BaseExceptionHandling {
  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };

  List<File> images = [];
  List<ReasonModel> reasonsObjects = [];
  List<String> reasons = [];
  MemberShipModel memberShipModel;
  File rokhsa;
  File idCard;

  int totalParkedCars;
  bool isVIP;
  int militaryCount;
  int civilCount;
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

  void deleteCarPath() {
    memberShipModel.carImagePath = null;
    notifyListeners();
  }

  void deleteIdPath() {
    memberShipModel.identityImagePath = null;
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

  Future<void> searchParking(
      String searchText, String filterType, int pageNumber) {
    if (searchText == '') {
      getParkingList(filterType, pageNumber);
    } else {
      parkingList = parkingList
          .where((item) => item.logId.toString().contains(searchText))
          .toList();
      print('search list length is ${parkingList.length}');
    }
    notifyListeners();
  }

  Future<dynamic> getVisitorTypes() async {
    try {
      if (visitorObjects.isNotEmpty) {
        print('visitorObjects not null');
        return;
      } else {
        print('visitorObjects null');

        var response = await BaseClient()
            .get(BASE_URL, '/api/guest/getOwners')
            .catchError(handleError);

        var jsonObj = jsonDecode(response)['response'] as List;

        visitorObjects =
            jsonObj.map((item) => VisitorTypesModel.fromJson(item)).toList();

        for (int i = 0; i < visitorObjects.length; i++) {
          debugPrint(visitorObjects[i].visitorType);
          if (!visitorTypes.contains(visitorObjects[i].visitorType)) {
            visitorTypes.add(visitorObjects[i].visitorType);
          }
        }

        debugPrint('length of visitor types ${visitorTypes[0]}');

        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getParkingList(String filterType, int pageNumber) async {
    debugPrint('filter type = $filterType  pageNumber = $pageNumber');
    String endPoint;

    if (filterType == 'الكل' && pageNumber == 1) {
      endPoint = '/api/Gate/Parked';
    } else if (filterType == 'الكل' && pageNumber != 1) {
      endPoint = '/api/Gate/Parked?pageNo=$pageNumber';
    } else {
      endPoint = '/api/Gate/Parked?parkType=$filterType&pageNo=$pageNumber';
    }

    try {
      var response =
          await BaseClient().get(BASE_URL, endPoint).catchError(handleError);

      var parkJsonObj = jsonDecode(response)['response']['parkedDTO'] as List;
      var reasonsJsonObj =
          jsonDecode(response)['response']['reasonDTO'] as List;
      totalParkedCars = jsonDecode(response)['response']['count'];
      debugPrint('all parked cars $totalParkedCars');
      debugPrint('parking response  $parkJsonObj');
      debugPrint('reasons response  $reasonsJsonObj');

      parkingList =
          parkJsonObj.map((item) => ParkingCarsModel.fromJson(item)).toList();
      reasonsObjects =
          reasonsJsonObj.map((item) => ReasonModel.fromJson(item)).toList();

      for (int i = 0; i < reasonsObjects.length; i++) {
        debugPrint(reasonsObjects[i].reason);
        if (!reasons.contains(reasonsObjects[i].reason)) {
          reasons.add(reasonsObjects[i].reason);
        }
      }

      parkingList = parkingList.reversed.toList();

      debugPrint('parking length  ${parkingList.length}');
      debugPrint('reasons length  ${reasons.length}');

      notifyListeners();
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<ResponseData> checkIn(File carImg, File identityImg, String userID,
      int typeID, int citizenCount, int militaryCount, BuildContext context,
      [String image1, String image2]) async {
    ResponseData responseData = ResponseData();
    debugPrint('userID $userID');

    var uri = Uri.parse('$BASE_URL/api/gate/CheckIn');

    var request = http.MultipartRequest('POST', uri);

    if (carImg != null && identityImg != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', carImg.path),
      );
      request.files.add(
        await http.MultipartFile.fromPath('file1', identityImg.path),
      );
    }
    if (image1 != null && image2 != null) {
      request.fields['image1'] = image1;
      request.fields['image2'] = image2;
    }
    request.fields['UserID'] = userID.toString();
    request.fields['TypeID'] = typeID.toString();
    request.fields['militryCount'] = militaryCount.toString();
    request.fields['civilCount'] = citizenCount.toString();

    request.headers.addAll(mHeaders);

    try {
      await request.send().then((response) async {
        debugPrint('status code is ${response.statusCode}');
        if (response.statusCode == 401) {
          responseData.message = 'unAuth';
        }
        response.stream.transform(utf8.decoder).listen((value) {
          Map<String, dynamic> responseDecoded = json.decode(value);
          debugPrint("ah ah ${responseDecoded['response']}");

          debugPrint('message is ${responseDecoded['message']}');
          if (responseDecoded['message'] == 'Success') {
            responseData.message = 'Success';
            qrCode = responseDecoded['response']['qrCode'];
            printTime = responseDecoded['response']['printTime'];
            logId = responseDecoded['response']['id'];
          }
        });
      }).catchError((e) {
        debugPrint(e.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
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
    debugPrint('userID $userID');

    var uri = Uri.parse('$BASE_URL/api/invitation/CheckInInvitation');
    var request = http.MultipartRequest('POST', uri);

    if (carImg != null && identityImg != null) {
      debugPrint('images not null');
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
        response.stream.transform(utf8.decoder).listen((value) {
          Map<String, dynamic> responseDecoded = json.decode(value);
          debugPrint("ah ah ${responseDecoded['response']}");

          debugPrint('message is ${responseDecoded['message']}');
          if (responseDecoded['message'] == 'Success') {
            responseData.message = 'Success';
            qrCode = responseDecoded['response']['qrCode'];
            printTime = responseDecoded['response']['printTime'];
            logId = responseDecoded['response']['id'];
          }
        });
      }).catchError((e) {
        debugPrint(e);
      });
    } catch (e) {
      debugPrint(e);
    }
    notifyListeners();
    return responseData;
  }

  Future<ResponseData> checkInPerHour(
    String userID,
    File carImg,
    File identityImg,
  ) async {
    ResponseData responseData = ResponseData();
    debugPrint('userID in per hour $userID');

    var uri = Uri.parse('$BASE_URL/api/Hours/CheckInHour');

    var request = http.MultipartRequest('POST', uri);

    if (carImg != null && identityImg != null) {
      debugPrint('images not null');
      request.files.add(
        await http.MultipartFile.fromPath('image1', carImg.path),
      );
      request.files.add(
        await http.MultipartFile.fromPath('image2', identityImg.path),
      );
    }

    request.fields['UserId'] = userID.toString();
    request.headers.addAll(mHeaders);

    try {
      await request.send().then((response) async {
        response.stream.transform(utf8.decoder).listen((value) {
          Map<String, dynamic> responseDecoded = json.decode(value);
          debugPrint("response ${responseDecoded['response']}");
          debugPrint('message is ${responseDecoded['message']}');
          if (responseDecoded['message'] == 'Success') {
            responseData.message = 'Success';
            qrCode = responseDecoded['response']['qrCode'];
            printTime = responseDecoded['response']['inTime'];
            logId = responseDecoded['response']['id'];
          }
        });
      }).catchError((e) {
        debugPrint(e.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
    return responseData;
  }

  Future<dynamic> getBill(
      String typeID, String citizenCount, String militaryCount) async {
    debugPrint('type id $typeID');
    String data = '';

    try {
      var response = await BaseClient().post(BASE_URL, '/api/gate/bill', {
        'TypeID': typeID,
        'militryCount': militaryCount,
        'civilCount': citizenCount
      }).catchError(handleError);

      String responseBody = response;

      var decodedRes = jsonDecode(responseBody);

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
      debugPrint(e.toString());
    }
  }

  Future<dynamic> getLogById(int logId) async {
    String data = '';

    try {
      var response = await BaseClient()
          .post(BASE_URL, '/api/gate/GetLogByID/$logId')
          .catchError(handleError);

      var decodedRes = jsonDecode(response);

      if (decodedRes['message'] == 'Success') {
        qrCode = decodedRes['response']['qrCode'];
        militaryCount = decodedRes['response']['militryCount'];
        civilCount = decodedRes['response']['civilCount'];
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
      debugPrint(e);
    }
  }

  Future<dynamic> confirmPrint(String userId, int logId, int reasonId) async {
    String data = '';
    debugPrint('logId $logId  userId $userId  reasonId $reasonId');

    try {
      var response = await BaseClient()
          .post(BASE_URL,
              '/api/gate/print?UserID=$userId&LogID=$logId&ReasonID=$reasonId')
          .catchError(handleError);

      var decodedRes = jsonDecode(response);

      debugPrint('response is $decodedRes');

      if (decodedRes['message'] == 'Success') {
        printTime = decodedRes['response']['printTime'];
        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> cancel(int logId) async {
    String data = '';

    try {
      var response = await BaseClient()
          .delete(BASE_URL, '/api/gate/Cancel/$logId')
          .catchError(handleError);

      var decodedRes = jsonDecode(response);
      debugPrint('response is $decodedRes');
      if (decodedRes['message'] == 'Success') {
        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<dynamic> confirmPerHour(int logId, String userId) async {
    String data = '';

    try {
      var response = await BaseClient()
          .put(BASE_URL,
              '/api/Hours/ConfirmCheckOutHour?Id=$logId&UserId=$userId')
          .catchError(handleError);
      debugPrint('ConfirmCheckOutHour?I $response');

      var decodedRes = jsonDecode(response);

      debugPrint('response is $decodedRes');
      if (decodedRes['message'] == 'Success') {
        data = 'Success';
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> checkOut(String qrCode) async {
    dynamic data = '';

    debugPrint('qrCode $qrCode');

    try {
      var uri = Uri.parse('$BASE_URL/api/gate/CheckOut');
      var request = http.MultipartRequest('PUT', uri);
      request.fields['QrCode'] = qrCode;
      request.headers.addAll(mHeaders);

      await request.send().then((response) async {
        // ignore: void_checks
        response.stream.transform(utf8.decoder).listen((value) {
          Map<String, dynamic> responseDecoded = json.decode(value);

          debugPrint('message is $responseDecoded');

          if (responseDecoded['message'] == 'Success') {
            debugPrint('SUCCESS YA MAN');

            if (responseDecoded['response'].toString() == 'true') {
              debugPrint('NORMAL');

              data = 'Success';
            } else {
              debugPrint('PER HOUR');

              data = PerHour();
              data.id = responseDecoded['response']['id'];
              data.inTime = responseDecoded['response']['inTime'];
              data.outTime = responseDecoded['response']['outTime'];
              data.qrCode = responseDecoded['response']['qrCode'];
              data.total =
                  double.parse(responseDecoded['response']['total'].toString());
              if (responseDecoded['response']['isPayed'].toString() == 'true') {
                data.isPaid = true;
              } else {
                data.isPaid = false;
              }
            }
          } else {
            debugPrint('NOT SUCCESS');
            data = responseDecoded['message'];
          }
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
    return data;
  }

  Future<dynamic> checkOutInvitation(String qrCode) async {
    String data = '';
    debugPrint('qrCode $qrCode');

    try {
      var uri = Uri.parse('$BASE_URL/api/Invitation/ScanInvitationQr');
      var request = http.MultipartRequest('POST', uri);

      request.fields['QrCode'] = qrCode;
      request.headers.addAll(mHeaders);

      try {
        await request.send().then((response) async {
          debugPrint(' status code = ${response.statusCode}');

          response.stream.transform(utf8.decoder).listen((value) {
            Map<String, dynamic> responseDecoded = json.decode(value);
            debugPrint("response ${responseDecoded['response']}");
            invitationID = responseDecoded['response']['id'];
            isVIP = responseDecoded['response']['isVIP'];

            debugPrint('message is $responseDecoded');

            if (isVIP) {
              data = 'vip';
            } else if (responseDecoded['message'] == 'Success') {
              data = 'Success';
            }
          });
        }).catchError((e) {
          debugPrint(e);
        });
      } catch (e) {
        debugPrint(e);
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<dynamic> checkInMemberShip(String qrCode) async {
    String data = '';
    debugPrint('qrCode $qrCode');

    try {
      Uri uri = Uri.parse('$BASE_URL/api/MemberShip/ScanMemberQR');
      http.MultipartRequest request = http.MultipartRequest('POST', uri);
      request.fields['QrCode'] = qrCode;
      request.headers.addAll(mHeaders);
      try {
        await request.send().then((response) async {
          response.stream.transform(utf8.decoder).listen((value) {
            Map<String, dynamic> responseDecoded = json.decode(value);

            debugPrint('response is $responseDecoded');

            if (responseDecoded['message'] == 'Success') {
              data = 'Success';
              memberShipModel = MemberShipModel();
              memberShipModel.carImagePath =
                  responseDecoded['response']['image1'] != null
                      ? responseDecoded['response']['image1'].toString()
                      : 'first time';

              memberShipModel.identityImagePath =
                  responseDecoded['response']['image2'] != null
                      ? responseDecoded['response']['image2'].toString()
                      : 'first time';
              memberShipModel.id = responseDecoded['response']['id'];
              memberShipModel.ownerTypeId =
                  responseDecoded['response']['ownerTypeId'];
            }
            debugPrint('image one is ${memberShipModel.carImagePath}');
          });
        }).catchError((e) {
          debugPrint(e.toString());
        });
      } catch (e) {
        debugPrint(e.toString());
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> updateMemberShipImages(
      int id, File carImage, File identityImage) async {
    String data = '';

    try {
      Uri uri = Uri.parse('$BASE_URL/api/MemberShip/UpdateImage');
      http.MultipartRequest request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath('file', carImage.path),
      );
      request.files.add(
        await http.MultipartFile.fromPath('file1', identityImage.path),
      );
      request.fields['Id'] = id.toString();

      request.headers.addAll(mHeaders);

      try {
        await request.send().then((response) async {
          response.stream.transform(utf8.decoder).listen((value) {
            Map<String, dynamic> responseDecoded = json.decode(value);
            debugPrint('response is ${responseDecoded['response']}');
            if (responseDecoded['message'] == 'Success') {
              data = 'Success';
              memberShipModel.carImagePath =
                  responseDecoded['response']['image1'];
              memberShipModel.identityImagePath =
                  responseDecoded['response']['image2'];
            }
          });
        }).catchError((e) {
          debugPrint(e.toString());
        });
      } catch (e) {
        debugPrint(e.toString());
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
