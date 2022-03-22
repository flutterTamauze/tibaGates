class PublicHolidaysModel {
  int id;
  String startDate;
  String endDate;
  String description;

  PublicHolidaysModel(
      {this.id, this.startDate, this.endDate, this.description});

  factory PublicHolidaysModel.fromJson(json) {
    return PublicHolidaysModel(
      id: json['id'],
      startDate: json['startDate'],
      description: json['description'],
      endDate: json['endDate'],
    );
  }
}
