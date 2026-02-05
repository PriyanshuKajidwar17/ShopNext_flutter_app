import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CheckoutProvider extends ChangeNotifier {
  Map<String, String>? address;
  List<Product> products = [];
  double totalAmount = 0;

  // ✅ this flag controls everything
  bool get hasAddress => address != null;

  void setAddress(Map<String, String> data) {
    address = data;
    notifyListeners();
  }

  void setOrder(List<Product> items, double total) {
    products = items;
    totalAmount = total;
    notifyListeners();
  }

  // ❌ DO NOT clear address here
  void clearOrder() {
    products = [];
    totalAmount = 0;
    notifyListeners();
  }
}
