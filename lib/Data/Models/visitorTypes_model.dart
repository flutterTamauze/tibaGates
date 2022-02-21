class VisitorTypesModel {
  int id;
  String visitorType;

  VisitorTypesModel({this.id, this.visitorType});

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': visitorType,
      };

  factory VisitorTypesModel.fromJson( json) {
    print('json ${json["type"]}');
    return VisitorTypesModel(
      id: json["id"],
      visitorType: json["type"] ?? "",
    );
  }
}
