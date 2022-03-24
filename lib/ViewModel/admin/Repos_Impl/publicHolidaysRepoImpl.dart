import 'dart:convert';
import 'package:clean_app/ViewModel/manager/managerProv.dart';
import 'package:clean_app/api/base_exception_handling.dart';
import 'package:dartz/dartz.dart';

import '../../../Data/Models/admin/publicHolidaysModel.dart';
import '../../../Data/Models/response.dart';
import 'package:flutter/foundation.dart';
import '../../../Utilities/Constants/constants.dart';
import '../../../api/base_client.dart';
import '../Repos/publicHolidaysRepo.dart';

class PublicHolidaysRepoImpl
    with BaseExceptionHandling
    implements PublicHolidaysRepo {
  @override
  Future<Either<Failure, ResponseData>> getPublicHolidays() async {
    ResponseData responseData;

    var jsonResponse = await BaseClient()
        .get(BASE_URL, '/api/Holiday/GetOfficialHoliday')
        .catchError(handleError);

    debugPrint(' message is ${jsonDecode(jsonResponse)['message']}');

    if (jsonDecode(jsonResponse)['message'] == 'Success') {
      responseData = ResponseData();
      responseData.message = 'Success';
      var publicHolidaysObj = jsonDecode(jsonResponse)['response'] as List;
      responseData.data = publicHolidaysObj
          .map((item) => PublicHolidaysModel.fromJson(item))
          .toList();
      responseData.data = responseData.data.reversed.toList();
      debugPrint('public holidays length is ${responseData.data.length}');
      return Right(responseData);
    } else {
      return Left(Failure('error yaba'));
    }
  }

  @override
  Future updatePublicHolidays(
      int id, String startDate, String endDate, String description) {
    return BaseClient().put(BASE_URL, '/api/Holiday/UpdateOfficialHoliday', {
      'id': id,
      'startDate': startDate,
      'endDate': endDate,
      'description': description
    }).catchError(handleError);
  }

  @override
  Future addPublicHolidays(
      String startDate, String endDate, String description) {
    return BaseClient().post(BASE_URL, '/api/Holiday/AddOfficialHoliday', {
      'startDate': startDate,
      'endDate': endDate,
      'description': description
    }).catchError(handleError);
  }

  @override
  Future deleteHoliday(int holidayId) {
    return BaseClient()
        .delete(BASE_URL, '/api/Holiday/DeleteOfficialHoliday?ID=$holidayId')
        .catchError(handleError);
  }
}
