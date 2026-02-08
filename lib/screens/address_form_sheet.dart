import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/checkout_provider.dart';

class AddressFormSheet extends StatefulWidget {
  const AddressFormSheet({super.key});

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final Map<String, String> data = {};

  late int a, b;
  final captchaController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    generateCaptcha();

    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _scaleAnim =
        CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
  }

  void generateCaptcha() {
    a = Random().nextInt(9) + 1;
    b = Random().nextInt(9) + 1;
  }

  @override
  void dispose() {
    captchaController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // ⭐ SUCCESS ANIMATION
  void showSuccess() async {
    await _animController.forward();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.check_circle,
                color: Colors.green, size: 80),
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1200));

    Navigator.pop(context); // close dialog
    Navigator.pop(context); // close sheet
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Add Delivery Address",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),

              _field(
                "Full Name",
                Icons.person,
                validator: (v) =>
                RegExp(r'^[a-zA-Z ]+$').hasMatch(v!)
                    ? null
                    : "Enter valid name",
              ),

              _field(
                "Mobile",
                Icons.phone,
                keyboard: TextInputType.phone,
                validator: (v) =>
                RegExp(r'^[6-9]\d{9}$').hasMatch(v!)
                    ? null
                    : "Invalid mobile",
              ),

              _field("House / Flat", Icons.home),
              _field("Street", Icons.map),
              _field("City", Icons.location_city),
              _field("State", Icons.flag),

              _field(
                "Pincode",
                Icons.pin_drop,
                keyboard: TextInputType.number,
                validator: (v) =>
                RegExp(r'^\d{6}$').hasMatch(v!)
                    ? null
                    : "Invalid pincode",
              ),

              const SizedBox(height: 14),

              // CAPTCHA
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "CAPTCHA: $a + $b = ?",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: captchaController,
                      keyboardType: TextInputType.number,
                      decoration:
                      const InputDecoration(hintText: "Enter answer"),
                      validator: (v) =>
                      v == (a + b).toString()
                          ? null
                          : "Wrong CAPTCHA",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ⭐ FIXED BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A3CBC),
                  foregroundColor: Colors.white, // ✅ TEXT FIX
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<CheckoutProvider>().setAddress(data);
                    showSuccess();
                  }
                },
                child: const Text("Save Address"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
      String label,
      IconData icon, {
        TextInputType keyboard = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        keyboardType: keyboard,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF6A3CBC)),
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
        ),
        validator: validator ??
                (v) => v!.isEmpty ? "Required" : null,
        onChanged: (v) => data[label] = v,
      ),
    );
  }
}
