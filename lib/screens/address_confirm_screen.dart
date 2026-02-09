import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/checkout_provider.dart';
import 'address_form_sheet.dart';
import 'payment_screen.dart';

class AddressConfirmScreen extends StatelessWidget {
  const AddressConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Address"),
        backgroundColor: const Color(0xFF6A3CBC),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Delivery Address",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  checkout.address!.values.join(", "),
                ),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const AddressFormSheet(),
                );
              },
              child: const Text("Edit Address"),
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // 🔴 CHANGED: Background color matched with Confirm Address button
               // backgroundColor: const Color(0xFF4CAF50),
               // backgroundColor: Colors.amber,
                backgroundColor: const Color(0xFF8B5CF6), // 🔹 light purple
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentScreen(),
                  ),
                );
              },
              child: const Text("Continue to Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
