import '../../../Utilities/Constants/constants.dart';

class ReportsItemModel {
  int id;
  String type;
  int militryCount;
  int civilCount;
  String inDateTime;
  String outDateTime;
  String image1, image2;
  String inDate;
  String outDate;
  String userName;
   double total;
  ReportsItemModel(
      {this.type,
      this.inDate,
        this.userName,this.outDate,
      this.civilCount,
      this.id,
      this.militryCount,this.total,
      this.outDateTime,
      this.inDateTime,
      this.image1,
      this.image2});

  factory ReportsItemModel.fromJson(json) {
    return ReportsItemModel(
      image1: "$BASE_URL${json["image1"].toString().replaceAll("\\", "/")}",
      image2: "$BASE_URL${json["image2"].toString().replaceAll("\\", "/")}",
      id: json['id'],
      type: json['parkType'],
      inDate: json['inDate'],
      outDate: json['outDate']??'  -  ',
      total:    double.parse(json['total'].toString())    ,
      militryCount: json['militryCount'],
      civilCount: json['civilCount'],
      inDateTime: json['inTime'],
      userName: json['userName']?? '  -  ',
      outDateTime: json['outTime'] ?? '  -  ',
    );
  }
}
