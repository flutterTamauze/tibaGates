class SummaryModel {
  int carsCount;
  int memberCarCount;
  int militryCarCount;
  int citizenCarCount;
  int militryCount;
  int civilCount;
  int activityCarCount;
  double parkPrice;
  double militryPrice;
  double civilPrice;
  double total;
  double rePrintFines;
  double total_Fines;

  SummaryModel(
      {this.militryCount,
      this.civilCount,
      this.carsCount,
      this.militryPrice,
      this.militryCarCount,
      this.memberCarCount,
      this.civilPrice,
      this.citizenCarCount,
      this.activityCarCount,
      this.total,
      this.parkPrice,
      this.rePrintFines,
      this.total_Fines});

  factory SummaryModel.fromJson(json) {
    return SummaryModel(
      militryCount: json['militryCount'],
      civilCount: json['civilCount'],
      carsCount: json['count'],
      militryPrice: double.parse(json['militryPrice'].toString()),
      militryCarCount: json['militryCarCount'],
      memberCarCount: json['memberCarCount'],
      civilPrice: double.parse(json['civilPrice'].toString()),
      citizenCarCount: json['citizenCarCount'],
      activityCarCount: json['activityCarCount'],
      total: double.parse(json['total'].toString()),
      parkPrice: double.parse(json['parkPrice'].toString()),
      rePrintFines: double.parse(json['rePrintFines'].toString()),
      total_Fines: double.parse(json['total_Fines'].toString()),
    );
  }
}
