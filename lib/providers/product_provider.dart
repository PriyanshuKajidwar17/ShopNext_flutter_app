import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  int _limit = 12;
  bool _isLoading = false;

  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;

  // 🔍 SEARCH QUERY
  String _searchQuery = "";

  Future<void> loadInitialProducts() async {
    _isLoading = true;
    notifyListeners();

    _allProducts = await ApiService.fetchProducts(_limit);
    _applySearch();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    _limit += 6;
    _allProducts = await ApiService.fetchProducts(_limit);
    _applySearch();

    _isLoading = false;
    notifyListeners();
  }

  // 🔍 UPDATE SEARCH
  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts = _allProducts
          .where((product) =>
          product.title.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }
}
