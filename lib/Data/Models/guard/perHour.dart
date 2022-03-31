class PerHour {
  int id;
  String qrCode;
  bool isPaid;
  double total;
  String inTime;
  String outTime;
  PerHour(
      {this.inTime,
      this.isPaid,
      this.outTime,
      this.total,
      this.id,
      this.qrCode});
}
