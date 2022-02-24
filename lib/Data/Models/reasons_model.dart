class ReasonModel {
  int id;
  String reason;
  double price;

  ReasonModel({
    this.id,
    this.reason,
    this.price,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'reason': reason,
    'price': price,
  };

  factory ReasonModel.fromJson(dynamic json) {
    return ReasonModel(
      id: json["id"],
      price:double.parse(json["price"].toString()) ,
      reason: json["reason"] ?? "",
    );
  }
}

