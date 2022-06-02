import 'dart:convert';

import '../../../Data/Models/admin/a_summary_model.dart';
import '../../../api/base_client.dart';
import '../../../api/base_exception_handling.dart';

import '../../../Data/Models/admin/reportsItemModel.dart';
import '../../../Utilities/Constants/constants.dart';
import 'package:flutter/material.dart';

class AReportsProv with ChangeNotifier, BaseExceptionHandling {
  List<ReportsItemModel> reportsList = [];
  SummaryModel summaryModel = SummaryModel();




  Future<dynamic> deleteBill(int billId, String userId) async {
    String data = '';
    debugPrint('bill id $billId   userId $userId');
    try {
      var response = await BaseClient()
          .delete(BASE_URL, '/api/gate/cancel?logId=$billId&UserID=$userId')
          .catchError(handleError);

      var decodedRes = jsonDecode(response);

      debugPrint('response is $decodedRes');
      debugPrint('message is ${decodedRes['message']}');

      if (decodedRes['message'] == 'Success') {
        data = 'success';

        reportsList.removeWhere((element) => element.id == billId);
      }

      notifyListeners();
      return data;
    } catch (e) {
      print(e);
    }
  }


  Future<String> getDailyReport(String startDate, String endDate,
      [String parkType, int pageNumber = 0]) async {
    String message = '';
    print(
        'start $startDate    end $endDate   park type $parkType   pagenumber $pageNumber');
    String endPoint;

    if (parkType == null || parkType == 'الكل') {
      endPoint =
          '/api/gate/ReportLogs?StartDate=$startDate&EndDate=$endDate&pageNo=$pageNumber';
    } else {
      endPoint =
          '/api/gate/ReportLogs?StartDate=$startDate&EndDate=$endDate&ParkType=$parkType&pageNo=$pageNumber';
    }
    debugPrint('endpoint is $endPoint');
    try {
      var response =
          await BaseClient().get(BASE_URL, endPoint).catchError(handleError);

      debugPrint('response ${jsonDecode(response)['response']}');

      if (jsonDecode(response)['message'] == 'Success') {
        message = 'Success';
        var reportJsonObj = jsonDecode(response)['response']['logDTO'] as List;
        var summaryDTOJsonObj = jsonDecode(response)['response']['summaryDTO'];

        debugPrint('reports response  $reportJsonObj');
        reportsList = reportJsonObj
            .map((item) => ReportsItemModel.fromJson(item))
            .toList();

        summaryModel = SummaryModel.fromJson(summaryDTOJsonObj);

        debugPrint('summary count ${summaryModel.carsCount.toString()}');
        reportsList = reportsList.reversed.toList();
        debugPrint('reports length  ${reportsList.length}');
      } else {
        debugPrint('message is ${jsonDecode(response)['message']}');
      }

      notifyListeners();
      return message;
    } catch (e) {
      debugPrint(e.toString() ?? '');
    }
  }
}
