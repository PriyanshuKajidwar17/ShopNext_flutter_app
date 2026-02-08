import 'dart:math';
import 'package:flutter/material.dart';

import '../../utils/auth_helper.dart';
import '../home_screen.dart';
import 'otp_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');

  late AnimationController _controller;
  late Animation<double> _bikeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bikeAnimation = Tween<double>(begin: -40, end: 40).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: const Color(0xFF2874F0),
      backgroundColor: const Color(0xFF6A3CBC),

        body: Column(
        children: [
          const SizedBox(height: 40),

          /// 🔝 TOP BAR (ICON + APP NAME + SKIP)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shopping_bag,
                        color: Color(0xFF2874F0),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "ShopNext",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    AuthHelper.setLoggedIn();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          /// 🚴 BIKE RIDING ANIMATION (STILL ON)
          AnimatedBuilder(
            animation: _bikeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_bikeAnimation.value, 0),
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.directions_bike,
                    color: Colors.white, size: 42),
                SizedBox(width: 6),
                Icon(Icons.shopping_bag,
                    color: Colors.white, size: 28),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// WHITE CARD
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Login to get started",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        prefixText: "+91 ",
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter phone number";
                        } else if (!phoneRegex.hasMatch(value)) {
                          return "Enter valid Indian number";
                        }
                        return null;
                      },
                    ),

                    const Spacer(),

                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 160,
                        height: 48,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Continue"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final otp =
                              (Random().nextInt(900000) + 100000).toString();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OTPScreen(
                                    phone: phoneController.text,
                                    generatedOtp: otp,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
