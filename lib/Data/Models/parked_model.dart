
import 'package:clean_app/Utilities/Constants/constants.dart';

class ParkingCarsModel {
  String carImage, identityImage;
  var type;
  int logId;

  ParkingCarsModel({this.type, this.logId, this.carImage, this.identityImage});

  factory ParkingCarsModel.fromJson(dynamic json) {
    return ParkingCarsModel(
      carImage: "$BASE_URL${json["image1"].toString().replaceAll("\\", "/")}",
      identityImage:
          "$BASE_URL${json["image2"].toString().replaceAll("\\", "/")}",
      logId: json["id"],
      type: json["car"] ?? "",
    );
  }
}
