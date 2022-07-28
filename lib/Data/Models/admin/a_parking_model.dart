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
        inDateTime: '${json['inDate'] ?? ''}  ${json['inTime'] ?? ''}',
        outDateTime: '${json['outDate'] ?? ''}  ${json['outTime'] ?? ''}',
        militryCount: json['militryCount'],
        parkType: json['parkType'],
        totalPrice: double.parse(json['total'].toString()));
  }
}
/*

class ParkingSummary {
  int carsCount;
  int memberCarCount;
  int militryCarCount;
  int citizenCarCount;
  int activityCarCount;
  double parkPrice;
  double militryPrice;
  double civilPrice;
  int militryCount;
  int civilCount;
  double total;
  double totalFines;

  ParkingSummary(
      {this.carsCount,
      this.militryCount,
      this.civilCount,
      this.parkPrice,
      this.total,
      this.activityCarCount,
      this.citizenCarCount,
      this.civilPrice,
      this.memberCarCount,
      this.militryCarCount,
      this.militryPrice,
      this.totalFines});

  factory ParkingSummary.fromJson(json) {
    return ParkingSummary(
        civilCount: json['civilCount'],
        activityCarCount: json['activityCarCount'],
        carsCount: json['count'],
        citizenCarCount: json['citizenCarCount'],
        civilPrice: json['civilPrice'],
        memberCarCount: json['memberCarCount'],
        militryCarCount: json['militryCarCount'],
        militryCount: json['militryCount'],
        militryPrice: json['militryPrice'],
        parkPrice: json['parkPrice'],
        total: json['total'],
        totalFines: json['total_Fines']);
  }
}

class Parking {
  ParkingSummary parkingSummary;
  //List<ParkingModel> parkingModel;

  Parking({this.parkingSummary*/
/*, this.parkingModel*//*
});

  factory Parking.fromJson(json) {
    return Parking(
       */
/* parkingModel: parseItems(json),*//*
 parkingSummary: ParkingSummary.fromJson('summaryDTO'));
  }

  static List<ParkingModel> parseItems(parkingJson) {
    var list = parkingJson['parkedDTO'] as List;
    List<ParkingModel> parkingCarsList =
        list.map((data) => ParkingModel.fromJson(data)).toList();
    return parkingCarsList;
  }
}
*/
