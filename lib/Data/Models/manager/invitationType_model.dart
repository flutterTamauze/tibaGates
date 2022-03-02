class InvitationTypesModel {
  int id;
  String invitationType;

  InvitationTypesModel({this.id, this.invitationType});

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': invitationType,
  };

  factory InvitationTypesModel.fromJson( json) {
    print('json ${json["type"]}');
    return InvitationTypesModel(
      id: json['id'],
      invitationType: json['type'] ?? '',
    );
  }
}
