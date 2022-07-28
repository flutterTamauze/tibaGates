class ServicesModel {
  int id;
  String serviceName;
  String arServiceName;
  double servicePrice;

  ServicesModel({ this.id, this.serviceName,this.servicePrice,this.arServiceName});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': serviceName,
    'arName': arServiceName,
    'price': serviceName,
  };

  factory ServicesModel.fromJson(json) {
    return ServicesModel(
      id: json['id'],
      serviceName: json['name'] ?? '',
      arServiceName: json['arName'] ?? '',
      servicePrice: double.parse( json['price'].toString())  ?? '',
    );
  }
}


