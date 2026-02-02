import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static Future<List<Product>> fetchProducts(int limit) async {
    final url = Uri.parse(
      'https://dummyjson.com/products?limit=$limit',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      List productsList = jsonData['products'];

      return productsList
          .map((e) => Product.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
