
class WeeklyHolidaysModel {
  int id;
  String day;
String isHoliday;

  WeeklyHolidaysModel({this.id, this.day, this.isHoliday});

  factory WeeklyHolidaysModel.fromJson(json) {
    return WeeklyHolidaysModel(
      id: json['id'],
      day: json['day'],
      isHoliday: json['isHoliday'].toString(),
    );
  }
}
