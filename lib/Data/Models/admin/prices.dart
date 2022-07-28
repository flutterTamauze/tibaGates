
class PricesModel {
  int id;
  String type;
  double price;
  double priceInHoliday;

  PricesModel({this.id, this.priceInHoliday, this.price, this.type});

  factory PricesModel.fromJson(json) {
    return PricesModel(
      id: json['id'],
      type: json['type'],
      price: double.parse(json['price'].toString()),
      priceInHoliday: double.parse(json['priceInHoliday'].toString()),
    );
  }
}
