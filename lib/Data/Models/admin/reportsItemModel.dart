class ReportsItemModel {
  int id;
  String type;
  int militryCount;
  int civilCount;
  String inDateTime;
  String outDateTime;

  ReportsItemModel({this.type, this.civilCount,this.id,this.militryCount,this.outDateTime,this.inDateTime});

  factory ReportsItemModel.fromJson(json) {

    return ReportsItemModel(
        id: json['id'],
        type: json['parkType'],
      militryCount: json['militryCount'],
      civilCount: json['civilCount'],
      inDateTime: json['inTime'],
      outDateTime: json['outTime']??'-',
    );
  }
}
