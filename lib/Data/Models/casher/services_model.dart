class ServicesModel {
  int id;
  String serviceName;
  double servicePrice;

  ServicesModel({ this.id, this.serviceName,this.servicePrice});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': serviceName,
    'price': serviceName,
  };

  factory ServicesModel.fromJson(json) {
    return ServicesModel(
      id: json['id'],
      serviceName: json['name'] ?? '',
      servicePrice: double.parse( json['price'].toString())  ?? '',
    );
  }
}
