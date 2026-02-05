import 'product_model.dart';

class Order {
  final String id;
  final DateTime date;
  final List<Product> products;
  final double totalAmount;
  final Map<String, String> address;

  Order({
    required this.id,
    required this.date,
    required this.products,
    required this.totalAmount,
    required this.address,
  });
}
