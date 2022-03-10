class HomeBioModel {
  int count;
  String type;

  HomeBioModel({this.type, this.count});

  factory HomeBioModel.fromJson(json) {
    return HomeBioModel(count: json['count'], type: json['parkType']);
  }
}
