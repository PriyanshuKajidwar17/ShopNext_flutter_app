import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payments = context.watch<PaymentProvider>().payments;

    return Scaffold(
      appBar: AppBar(title: const Text("Payment History"),
        backgroundColor: const Color(0xFF6A3CBC),
        elevation: 0,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),),
      body: payments.isEmpty
          ? const Center(child: Text("No payments yet"))
          : ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final p = payments[index]; // Map<String, dynamic>

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(
                p['method'] == "UPI"
                    ? Icons.qr_code
                    : p['method'] == "Card"
                    ? Icons.credit_card
                    : Icons.money,
              ),
              title: Text("₹${p['amount']} • ${p['method']}"),
              subtitle: Text(
                DateTime.parse(p['dateTime']).toString(),
              ),
              trailing: Text(
                p['status'],
                style: const TextStyle(color: Colors.green),
              ),
            ),
          );
        },
      ),
    );
  }
}
