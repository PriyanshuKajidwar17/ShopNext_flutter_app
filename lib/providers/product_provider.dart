import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  int _limit = 12;
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> loadInitialProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await ApiService.fetchProducts(_limit);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    _limit += 6; // load more items
    _products = await ApiService.fetchProducts(_limit);

    _isLoading = false;
    notifyListeners();
  }
}
