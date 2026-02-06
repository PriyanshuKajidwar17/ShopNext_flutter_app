import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  int _limit = 12;
  bool _isLoading = false;

  String _searchQuery = "";
  String _selectedCategory = "All";

  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;

  Future<void> loadInitialProducts() async {
    _isLoading = true;
    notifyListeners();

    _allProducts = await ApiService.fetchProducts(_limit);
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    _limit += 6;
    _allProducts = await ApiService.fetchProducts(_limit);
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  // 🔍 SEARCH
  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // 🏷️ CATEGORY
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // 🔄 COMBINED FILTER LOGIC
  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      final matchesSearch = product.title
          .toLowerCase()
          .contains(_searchQuery);

      final matchesCategory =
          _selectedCategory == "All" ||
              product.category
                  .toLowerCase()
                  .contains(_selectedCategory.toLowerCase());

      return matchesSearch && matchesCategory;
    }).toList();
  }
}
