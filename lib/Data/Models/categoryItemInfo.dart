import 'package:flutter/material.dart';

class CategoryItemInfo {
  String name, desc;
  int quantity, id;
  double price, rate;
  CategoryItemInfo(
      {required this.desc,
      required this.name,
      required this.id,
      required this.price,
      required this.quantity,
      required this.rate});
}
