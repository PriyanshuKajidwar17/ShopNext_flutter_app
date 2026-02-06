import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';

class CheckoutProvider extends ChangeNotifier {
  Map<String, String>? address;

  // ✅ Stores cart items WITH quantity
  List<CartItem> items = [];
  double totalAmount = 0;

  // Controls address flow
  bool get hasAddress => address != null;

  void setAddress(Map<String, String> data) {
    address = data;
    notifyListeners();
  }

  // ✅ Set order data from cart
  void setOrder(List<CartItem> cartItems, double total) {
    items = List.from(cartItems);
    totalAmount = total;
    notifyListeners();
  }

  // ❌ Do NOT clear address (better UX)
  void clearOrder() {
    items = [];
    totalAmount = 0;
    notifyListeners();
  }
}
