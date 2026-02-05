import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/checkout_provider.dart';

class AddressFormSheet extends StatefulWidget {
  const AddressFormSheet({super.key});

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet> {
  final formKey = GlobalKey<FormState>();
  final Map<String, String> data = {};

  late int a, b;
  final captchaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateCaptcha();
  }

  void generateCaptcha() {
    a = Random().nextInt(9) + 1;
    b = Random().nextInt(9) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _field("Full Name"),
              _field("Mobile"),
              _field("House / Flat"),
              _field("Street"),
              _field("City"),
              _field("State"),
              _field("Pincode"),

              const SizedBox(height: 12),
              Text("CAPTCHA: $a + $b = ?"),
              TextFormField(
                controller: captchaController,
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == (a + b).toString() ? null : "Wrong CAPTCHA",
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<CheckoutProvider>().setAddress(data);
                    Navigator.pop(context); // close sheet
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

  Widget _field(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (v) => v!.isEmpty ? "Required" : null,
        onChanged: (v) => data[label] = v,
      ),
    );
  }
}
