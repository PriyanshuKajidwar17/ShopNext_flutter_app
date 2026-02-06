import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/cart_item_model.dart';

class CheckoutProvider extends ChangeNotifier {
  Map<String, String>? address;
  List<CartItem> items = [];
  double totalAmount = 0;

  final _box = Hive.box('addressBox');

  bool get hasAddress => address != null;

  // ✅ LOAD ADDRESS
  void loadAddress() {
    address = _box.get('address')?.cast<String, String>();
    notifyListeners();
  }

  // ✅ SAVE ADDRESS
  void setAddress(Map<String, String> data) {
    address = data;
    _box.put('address', data);
    notifyListeners();
  }

  void setOrder(List<CartItem> cartItems, double total) {
    items = List.from(cartItems);
    totalAmount = total;
    notifyListeners();
  }

  void clearOrder() {
    items = [];
    totalAmount = 0;
    notifyListeners();
  }
}
