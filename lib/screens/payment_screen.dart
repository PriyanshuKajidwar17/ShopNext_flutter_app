import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/checkout_provider.dart';
import '../providers/order_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/payment_provider.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = "UPI";

  final TextEditingController upiController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: const Color(0xFF6A3CBC),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),

      // ✅ ONLY CHANGE IS HERE
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
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
            if (selectedMethod == "UPI")
              _inputField(upiController, "UPI ID", "example@upi"),

            _paymentOption(Icons.credit_card, "Card"),
            if (selectedMethod == "Card") ...[
              _inputField(cardController, "Card Number", "XXXX XXXX XXXX"),
              _inputField(nameController, "Card Holder Name", "Full Name"),
            ],

            _paymentOption(Icons.money, "Cash on Delivery"),

            // ✅ replaces Spacer() safely
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => _confirmPayment(context),
                child: Text(
                  "Pay ₹${checkout.totalAmount.toStringAsFixed(2)}",
                ),
              ),
            ),
          ],
        ),
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

  Widget _inputField(
      TextEditingController controller,
      String label,
      String hint,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
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
              final payments = context.read<PaymentProvider>();

              final orderId =
              DateTime.now().millisecondsSinceEpoch.toString();

              // ✅ SAVE ORDER
              orders.addOrder(
                items: checkout.items,
                total: checkout.totalAmount,
                address: checkout.address!,
              );

              // ✅ SAVE PAYMENT
              payments.addPayment(
                PaymentModel(
                  paymentId: "PAY$orderId",
                  orderId: orderId,
                  amount: checkout.totalAmount,
                  method: selectedMethod,
                  status: "SUCCESS",
                  dateTime: DateTime.now(),
                  upiId:
                  selectedMethod == "UPI" ? upiController.text : null,
                  cardLast4: selectedMethod == "Card"
                      ? cardController.text.substring(
                      cardController.text.length - 4)
                      : null,
                ),
              );

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
