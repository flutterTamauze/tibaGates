import 'dart:io';

import '../../../Utilities/Constants/constants.dart';

class MemberShipModel {
  int id;
  int ownerTypeId;
  String carImagePath;
  String identityImagePath;
  File identityImage;
  File carImage;
  MemberShipModel({
    this.id,
    this.ownerTypeId,
    this.carImagePath,
    this.identityImagePath,
    this.identityImage,
    this.carImage,
  });

  factory MemberShipModel.fromJson(json) {
    return MemberShipModel(
        carImagePath:
            "$BASE_URL${json["image1"].toString().replaceAll("\\", "/")}",
        identityImagePath:
            "$BASE_URL${json["image2"].toString().replaceAll("\\", "/")}",
        id: json['id'],
        ownerTypeId: json['ownerTypeId']);
  }
}
