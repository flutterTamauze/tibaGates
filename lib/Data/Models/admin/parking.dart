import '../../../Utilities/Constants/constants.dart';

class ParkingModel {
  int logId;
  int militryCount;
  int civilCount;
  String carImage;
  String identityImage;
  String parkType;

  double totalPrice;
  String inDateTime;
  String outDateTime;

  ParkingModel(
      {this.logId,
      this.carImage,
      this.identityImage,
      this.outDateTime,
      this.totalPrice,
      this.civilCount,
      this.inDateTime,
      this.militryCount,
      this.parkType});

  factory ParkingModel.fromJson(json) {
    return ParkingModel(
        carImage: "$BASE_URL${json["image1"].toString().replaceAll("\\", "/")}",
        identityImage:
            "$BASE_URL${json["image2"].toString().replaceAll("\\", "/")}",
        logId: json['id'],
        civilCount: json['civilCount'],
        inDateTime: '${json['inDate']??''}  ${json['inTime']??''}'  ,
        outDateTime: '${json['outDate']??''}  ${json['outTime']??''}'  ,
        militryCount: json['militryCount'],
        parkType: json['parkType'],
        totalPrice: double.parse(json['total'].toString()));
  }
}
