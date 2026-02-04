import 'package:flutter/material.dart';

class BuyNowScreen extends StatelessWidget {
  const BuyNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buy Now")),
      body: const Center(
        child: Text(
          "This page is in progress...",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
