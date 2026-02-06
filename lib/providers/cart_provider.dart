import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.length;

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  final _box = Hive.box('cartBox');

  // ✅ LOAD CART FROM HIVE
  void loadCart() {
    final data = _box.get('items');
    if (data != null) {
      _items.clear();
      _items.addAll(
        (data as List).map(
              (e) => CartItem(
            product: Product(
              id: e['id'],
              title: e['title'],
              price: e['price'],
              description: '',
              rating: 0,
              images: List<String>.from(e['images']),
            ),
            quantity: e['quantity'],
          ),
        ),
      );
    }
    notifyListeners();
  }

  // ✅ SAVE CART TO HIVE
  void _saveCart() {
    _box.put(
      'items',
      _items
          .map(
            (e) => {
          'id': e.product.id,
          'title': e.product.title,
          'price': e.product.price,
          'images': e.product.images,
          'quantity': e.quantity,
        },
      )
          .toList(),
    );
  }

  void addToCart(Product product) {
    final index =
    _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    _saveCart();
    notifyListeners();
  }

  void increaseQty(Product product) {
    final index =
    _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
      _saveCart();
      notifyListeners();
    }
  }

  void decreaseQty(Product product) {
    final index =
    _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      _saveCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _box.delete('items');
    notifyListeners();
  }
}
