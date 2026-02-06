import 'package:flutter/material.dart';
import 'dart:math';
import 'package:hive/hive.dart';

import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  final _box = Hive.box('orderBox');

  List<Order> get orders => _orders.reversed.toList();

  // ✅ LOAD ORDERS FROM HIVE (ON APP START)
  void loadOrders() {
    final data = _box.get('orders');

    if (data != null) {
      _orders.clear();

      for (var o in data) {
        _orders.add(
          Order(
            id: o['id'],
            date: DateTime.parse(o['date']),
            totalAmount: o['totalAmount'],
            address: Map<String, String>.from(o['address']),
            items: (o['items'] as List).map<CartItem>((i) {
              return CartItem(
                product: Product(
                  id: i['id'],
                  title: i['title'],
                  price: i['price'],
                  description: '',
                  rating: 0,
                  images: List<String>.from(i['images']),
                ),
                quantity: i['quantity'],
              );
            }).toList(),
          ),
        );
      }
    }

    notifyListeners();
  }

  // ✅ ADD ORDER + SAVE TO HIVE
  void addOrder({
    required List<CartItem> items,
    required double total,
    required Map<String, String> address,
  }) {
    final order = Order(
      id: Random().nextInt(999999).toString(),
      date: DateTime.now(),
      items: List.from(items),
      totalAmount: total,
      address: Map.from(address),
    );

    _orders.add(order);
    _saveOrders();
    notifyListeners();
  }

  // ✅ SAVE ORDERS AS MAP (IMPORTANT)
  void _saveOrders() {
    _box.put(
      'orders',
      _orders.map((o) {
        return {
          'id': o.id,
          'date': o.date.toIso8601String(),
          'totalAmount': o.totalAmount,
          'address': o.address,
          'items': o.items.map((i) {
            return {
              'id': i.product.id,
              'title': i.product.title,
              'price': i.product.price,
              'images': i.product.images,
              'quantity': i.quantity,
            };
          }).toList(),
        };
      }).toList(),
    );
  }
}
