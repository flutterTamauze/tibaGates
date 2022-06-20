import 'dart:convert';

import 'package:Tiba_Gates/Data/Models/common/hotel_guest_model.dart';

import '../../Utilities/Constants/constants.dart';
import '../../api/base_client.dart';
import '../../api/base_exception_handling.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;


class CommonProv with ChangeNotifier, BaseExceptionHandling {
  Map<String, String> mHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  };

  HotelGuestModel hotelGuestModel;

  Future<dynamic> checkBarcodeValidation(String barcode) async {
    String message;
    try {
      var response = await BaseClient()
          .get(BASE_URL, '/api/HotelCheckIn/ValidateCheckIn/$barcode')
          .catchError(handleError);

      var jsonObj = jsonDecode(response)['response'];
      if (jsonDecode(response)['message'] == 'Success') {
        message = 'Success';
        hotelGuestModel =  HotelGuestModel.fromJson(jsonObj);
        debugPrint('guest name is $hotelGuestModel');
      }

      notifyListeners();
      return message;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
