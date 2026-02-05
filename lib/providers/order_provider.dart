import 'package:flutter/material.dart';
import 'dart:math';

import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders.reversed.toList();

  void addOrder({
    required List products,
    required double total,
    required Map<String, String> address,
  }) {
    _orders.add(
      Order(
        id: Random().nextInt(999999).toString(),
        date: DateTime.now(),
        products: List.from(products),
        totalAmount: total,
        address: Map.from(address),
      ),
    );
    notifyListeners();
  }
}
