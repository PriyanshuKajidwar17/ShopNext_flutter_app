import 'package:flutter/material.dart';

import '../../utils/auth_helper.dart';
import '../home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String generatedOtp;

  const OTPScreen({
    super.key,
    required this.phone,
    required this.generatedOtp,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("OTP sent to +91 ${widget.phone}"),

            const SizedBox(height: 10),

            /// DEMO OTP
            Text(
              "Your OTP: ${widget.generatedOtp}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: otpController,
              maxLength: 6,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                errorText: error,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (otpController.text == widget.generatedOtp) {
                    AuthHelper.setLoggedIn(); // ✅ SAVE LOGIN
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                          (route) => false,
                    );
                  } else {
                    setState(() {
                      error = "Invalid OTP";
                    });
                  }
                },
                child: const Text("Verify & Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
