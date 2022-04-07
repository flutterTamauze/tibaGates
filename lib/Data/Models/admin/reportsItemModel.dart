import '../../../Utilities/Constants/constants.dart';

class ReportsItemModel {
  int id;
  String type;
  int militryCount;
  int civilCount;
  String inDateTime;
  String outDateTime;
  String image1,image2;

  ReportsItemModel({this.type, this.civilCount,this.id,this.militryCount,this.outDateTime,this.inDateTime,this.image1,this.image2});

  factory ReportsItemModel.fromJson(json) {

    return ReportsItemModel(
      image1: "$BASE_URL${json["image1"].toString().replaceAll("\\", "/")}",image2: "$BASE_URL${json["image2"].toString().replaceAll("\\", "/")}",
        id: json['id'],
        type: json['parkType'],
      militryCount: json['militryCount'],
      civilCount: json['civilCount'],
      inDateTime: json['inTime'],
      outDateTime: json['outTime']??'-',
    );
  }
}
