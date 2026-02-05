import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();

    // ⏳ Auto go back after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle,
                    size: 90, color: Colors.green),
                SizedBox(height: 16),
                Text(
                  "Payment Successful!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text("Thank you for your order 🎉"),
              ],
            ),
          ),

          // 🎊 CONFETTI FROM TOP
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: 1.57, // downward
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.3,
            shouldLoop: false,
          ),
        ],
      ),
    );
  }
}
