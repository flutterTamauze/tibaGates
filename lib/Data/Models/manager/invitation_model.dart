class Invitation {
  int id,status;
  String visitorName,visitorDescription,invitationType,creationDate,qrCode,inTime,outTime;

  Invitation({this.id, this.invitationType,this.qrCode,this.visitorName,this.status,this.creationDate,this.inTime,this.outTime,this.visitorDescription});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': visitorName,
    'description': visitorDescription,
    'invitationType': invitationType,
    'creationDate': creationDate,
    'qrCode': qrCode,
    'inTime': inTime??'',
    'outTime': outTime??'',
    'status': status,
  };

  factory Invitation.fromJson( json) {
    return Invitation(
      id: json['id'],
      visitorName: json['name'],
      visitorDescription: json['description'],
      invitationType: json['invitationType'],
      creationDate: json['creationDate'],
      qrCode: json['qrCode'],
      inTime: json['inTime']??'',
      outTime: json['outTime']??'',
      status: json['status'],
    );
  }
}
