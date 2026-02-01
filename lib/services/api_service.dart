import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static Future<List<Product>> fetchProducts(int limit) async {
    final url =
    Uri.parse('https://fakestoreapi.com/products?limit=$limit');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
