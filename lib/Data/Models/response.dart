import 'package:clean_app/ViewModel/manager/managerProv.dart';
import 'package:dartz/dartz.dart';

class ResponseData {
  String message;
  dynamic data;

  ResponseData({this.message, this.data});
}

class Response {
  Either<Failure, dynamic> data;
  Response(dynamic response) {
    if (response is Failure)
      data = Left(response);
    else
      data = Right(response);
  }
}