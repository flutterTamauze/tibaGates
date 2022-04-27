import 'dart:io';

import '../../../Utilities/Constants/constants.dart';

class MemberShipModel {
  int id;
  int ownerTypeId;

  String carImagePath;
  String memberName;
  String memberProfilePath;
  String identityImagePath;
  File identityImage;
  File carImage;
  List<MemberShipSportsModel> memberShipSports;

  MemberShipModel({
    this.id,
    this.memberName,
    this.memberShipSports,
    this.memberProfilePath,
    this.ownerTypeId,
    this.carImagePath,
    this.identityImagePath,
    this.identityImage,
    this.carImage,
  });

  factory MemberShipModel.fromJson(json) {
    return MemberShipModel(
        carImagePath: json['image1'] == null
            ? 'empty'
            : "$BASE_URL${json["image1"].toString().replaceAll("\\", "/")}",
        memberProfilePath: json['profileImage'] == null
            ? 'empty'
            : "$BASE_URL${json["profileImage"].toString().replaceAll("\\", "/")}",
        identityImagePath: json['image2'] == null
            ? 'empty'
            : "$BASE_URL${json["image2"].toString().replaceAll("\\", "/")}",
        id: json['id'],
        memberName: json['name'],
        memberShipSports: parseItems(json),
        ownerTypeId: json['ownerTypeId']);
  }

  static List<MemberShipSportsModel> parseItems(sportsJson) {
    var list = sportsJson['myGames'] as List;
    if (list != null) {
      List<MemberShipSportsModel> sportsList =
          list.map((data) => MemberShipSportsModel.fromJson(data)).toList();
      return sportsList;
    }
  }
}

class MemberShipSportsModel {
  int id;
  int gameId;
  String sportName;
  String sportExpireDate;
  bool isSelected;

  MemberShipSportsModel(
      {this.id, this.gameId,this.sportName, this.sportExpireDate, this.isSelected = false});

  factory MemberShipSportsModel.fromJson(json) {
    return MemberShipSportsModel(
      id: json['id'],
      gameId: json['gameId'],
      sportName: json['gameName'],
      sportExpireDate: json['endDate'],
    );
  }
}
