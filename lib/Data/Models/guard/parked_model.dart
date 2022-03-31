import '../../../Utilities/Constants/constants.dart';

class ParkingCarsModel {
  String carImage, identityImage;
  var type;
  int logId;
  int civilCount;
  int militaryCount;

  ParkingCarsModel(
      {this.type,
      this.logId,
      this.carImage,
      this.identityImage,
      this.civilCount,
      this.militaryCount});

  factory ParkingCarsModel.fromJson(json) {
    return ParkingCarsModel(
      carImage: "$BASE_URL${json["image1"].toString().replaceAll("\\", "/")}",
      identityImage:
          "$BASE_URL${json["image2"].toString().replaceAll("\\", "/")}",
      logId: json['id'],
      civilCount: json['civilCount'],
      militaryCount: json['militryCount'],
      type: json['car'] ?? '',
    );
  }
}
