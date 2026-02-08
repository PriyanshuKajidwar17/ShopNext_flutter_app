import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/checkout_provider.dart';
import '../providers/order_provider.dart';
import '../providers/cart_provider.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = "UPI";

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Payment"),
          backgroundColor: const Color(0xFF6A3CBC),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: ListTile(
              title: const Text("Total Amount"),
              trailing: Text(
                "₹${checkout.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          _paymentOption(Icons.qr_code, "UPI"),
          _paymentOption(Icons.credit_card, "Card"),
          _paymentOption(Icons.money, "Cash on Delivery"),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _confirmPayment(context),
              child: Text("Pay ₹${checkout.totalAmount.toStringAsFixed(2)}"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentOption(IconData icon, String title) {
    return RadioListTile(
      value: title,
      groupValue: selectedMethod,
      onChanged: (v) => setState(() => selectedMethod = v.toString()),
      title: Text(title),
      secondary: Icon(icon),
    );
  }

  void _confirmPayment(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: Text("Proceed with $selectedMethod payment?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final checkout = context.read<CheckoutProvider>();
              final orders = context.read<OrderProvider>();
              final cart = context.read<CartProvider>();

              // ✅ SAVE ORDER WITH QUANTITY
              orders.addOrder(
                items: checkout.items,
                total: checkout.totalAmount,
                address: checkout.address!,
              );

              // ✅ CLEAR STATES SAFELY
              cart.clearCart();
              checkout.clearOrder();

              Navigator.pop(context);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const PaymentSuccessScreen(),
                ),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
