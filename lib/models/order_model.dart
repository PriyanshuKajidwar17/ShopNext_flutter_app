import 'cart_item_model.dart';

class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items; // ✅ quantity preserved
  final double totalAmount;
  final Map<String, String> address;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
    required this.address,
  });
}
