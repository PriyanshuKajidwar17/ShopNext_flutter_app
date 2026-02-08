import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order #${order.id}"),
        backgroundColor: const Color(0xFF6A3CBC),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🛒 ITEMS
          const Text(
            "Items",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ...order.items.map((item) {
            return Card(
              child: ListTile(
                leading: Image.network(
                  item.product.images.first,
                  width: 50,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image),
                ),
                title: Text(item.product.title),
                subtitle: Text(
                  "₹${item.product.price} × ${item.quantity}",
                ),
                trailing: Text(
                  "₹${item.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          // 📍 ADDRESS
          const Text(
            "Delivery Address",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(order.address.values.join(", ")),
            ),
          ),

          const SizedBox(height: 20),

          // 💳 PAYMENT
          const Text(
            "Payment Method",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          const Card(
            child: ListTile(
              leading: Icon(Icons.payment),
              title: Text("Paid via UPI / Card"),
            ),
          ),

          const SizedBox(height: 20),

          // 💰 TOTAL
          Card(
            color: Colors.green.shade50,
            child: ListTile(
              title: const Text(
                "Order Total",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "₹${order.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
