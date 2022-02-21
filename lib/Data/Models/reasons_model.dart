class ReasonModel {
  int id;
  String reason;

  ReasonModel({
    this.id,
    this.reason,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'reason': reason,
  };

  factory ReasonModel.fromJson(dynamic json) {
    return ReasonModel(
      id: json["id"],
      reason: json["reason"] ?? "",
    );
  }
}

