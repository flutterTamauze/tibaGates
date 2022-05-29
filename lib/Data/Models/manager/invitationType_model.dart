class InvitationTypesModel {
  int id;
  String invitationType;

  InvitationTypesModel({this.id, this.invitationType});

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': invitationType,
  };

  factory InvitationTypesModel.fromJson( json) {
    return InvitationTypesModel(
      id: json['id'],
      invitationType: json['type'] ?? '',
    );
  }
}
