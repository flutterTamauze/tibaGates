
class HotelGuestModel {
  int id;
  String guestName;
  String hotelName;
  String startDate;
  String endDate;

  HotelGuestModel(
      {this.id,this.endDate,this.startDate,this.guestName,this.hotelName
    });

  factory HotelGuestModel.fromJson(json) {
    return HotelGuestModel(
      id: json['id'],
      guestName: json['customerName'],
      hotelName: json['hotelName'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}
