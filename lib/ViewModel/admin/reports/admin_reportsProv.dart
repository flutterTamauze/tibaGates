import 'dart:convert';

import 'package:clean_app/Data/Models/admin/a_summary_model.dart';

import '../../../Data/Models/admin/reportsItemModel.dart';
import '../../../Utilities/Constants/constants.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import 'package:http/http.dart' as http;

class AReportsProv with ChangeNotifier {
  List<ReportsItemModel> reportsList = [];
  SummaryModel summaryModel=SummaryModel();


  Future<String> getDailyReport(String startDate, String endDate,
      [String parkType,int pageNumber=0]) async {
    String message = '';
    print('start date $startDate    end date $endDate   park type $parkType   pagenumber $pageNumber');
    Map<String, String> mHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}'
    };

    String url;
    if (parkType == null) {
      url =
          '$BASE_URL/api/gate/ReportLogs?StartDate=$startDate&EndDate=$endDate&pageNo=$pageNumber';
    } else {
      url =
          '$BASE_URL/api/gate/ReportLogs?StartDate=$startDate&EndDate=$endDate&ParkType=$parkType&pageNo=$pageNumber';
    }

    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: mHeaders);

      print('statusCode ${response.statusCode}');
      print('response ${jsonDecode(response.body)['response']}');

      if (jsonDecode(response.body)['message'] == 'Success') {
        message = 'Success';
        var reportJsonObj =
            jsonDecode(response.body)['response']['logDTO'] as List;
        var summaryDTOJsonObj =
            jsonDecode(response.body)['response']['summaryDTO'];

        print('reports response  $reportJsonObj');
        reportsList = reportJsonObj
            .map((item) => ReportsItemModel.fromJson(item))
            .toList();

        summaryModel=SummaryModel.fromJson(summaryDTOJsonObj);

        print('summary count ${summaryModel.carsCount.toString()}');
        reportsList = reportsList.reversed.toList();
        print('reports length  ${reportsList.length}');
      } else {
        print('message is ${jsonDecode(response.body)['message']}');
      }

      notifyListeners();
      return message;
    } catch (e) {
      print(e);
    }
  }
}
