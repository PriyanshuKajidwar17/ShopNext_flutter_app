import 'package:flutter/material.dart';
import 'dart:math';

import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders.reversed.toList();

  // ✅ Add order with quantity info
  void addOrder({
    required List<CartItem> items,
    required double total,
    required Map<String, String> address,
  }) {
    _orders.add(
      Order(
        id: Random().nextInt(999999).toString(),
        date: DateTime.now(),
        items: List.from(items),
        totalAmount: total,
        address: Map.from(address),
      ),
    );
    notifyListeners();
  }
}
