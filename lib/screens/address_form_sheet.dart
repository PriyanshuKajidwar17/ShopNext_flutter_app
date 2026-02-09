import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart';
// 🔴 CHANGED: Needed for inputFormatters (mobile number restriction)

import '../providers/checkout_provider.dart';

class AddressFormSheet extends StatefulWidget {
  const AddressFormSheet({super.key});

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final houseController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinController = TextEditingController();
  final captchaController = TextEditingController();

  late int a, b;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    generateCaptcha();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnim =
        CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
  }

  void generateCaptcha() {
    a = Random().nextInt(9) + 1;
    b = Random().nextInt(9) + 1;
  }

  // ================= LOCATION =================
  Future<void> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    final place =
        (await placemarkFromCoordinates(pos.latitude, pos.longitude)).first;

    setState(() {
      cityController.text = place.locality ?? "";
      stateController.text = place.administrativeArea ?? "";
      pinController.text = place.postalCode ?? "";
    });
  }

  // ================= SUCCESS =================
  void showSuccess() async {
    await _animController.forward();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 76,
            ),
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1100));
    Navigator.pop(context);
    Navigator.pop(context);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF6F4FF), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        14,
        8,
        14,
        MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A3CBC).withOpacity(.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.location_on,
                        color: Color(0xFF6A3CBC), size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Add Delivery Address",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              _field(
                "Full Name",
                Icons.person,
                controller: nameController,
                validator: (v) =>
                RegExp(r'^[a-zA-Z ]{2,}$').hasMatch(v!)
                    ? null
                    : "Enter valid name",
              ),

              _field(
                "Mobile",
                Icons.phone,
                controller: mobileController,
                keyboard: TextInputType.phone,

                // CHANGED: Only digits & max 10 digits
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],

                // CHANGED: Indian mobile number (starts with 6–9)
                validator: (v) =>
                RegExp(r'^[6-9][0-9]{9}$').hasMatch(v!)
                    ? null
                    : "Enter valid Indian mobile number",
              ),

              _field("House / Flat", Icons.home,
                  controller: houseController),

              _field("Street", Icons.map,
                  controller: streetController, required: false),

              _field("City", Icons.location_city,
                  controller: cityController,
                  validator: (v) =>
                  RegExp(r'^[a-zA-Z ]+$').hasMatch(v!)
                      ? null
                      : "Invalid city"),

              _field("State", Icons.flag,
                  controller: stateController,
                  validator: (v) =>
                  RegExp(r'^[a-zA-Z ]+$').hasMatch(v!)
                      ? null
                      : "Invalid state"),

              _field("Pincode", Icons.pin_drop,
                  controller: pinController,
                  keyboard: TextInputType.number,
                  validator: (v) =>
                  RegExp(r'^\d{6}$').hasMatch(v!)
                      ? null
                      : "Invalid pincode"),

              const SizedBox(height: 6),

              OutlinedButton.icon(
                onPressed: getCurrentLocation,
                icon: const Icon(Icons.my_location, size: 18),
                label: const Text("Use Current Location"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6A3CBC),
                  side: const BorderSide(color: Color(0xFF6A3CBC)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                ),
              ),

              const SizedBox(height: 10),

              /// CAPTCHA
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A3CBC).withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text("Verify: $a + $b = ?",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: captchaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Answer",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) =>
                      v == (a + b).toString()
                          ? null
                          : "Wrong CAPTCHA",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              /// SAVE BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A3CBC),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 3,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final addressData = {
                      "Full Name": nameController.text.trim(),
                      "Mobile": mobileController.text.trim(),
                      "House": houseController.text.trim(),
                      "Street": streetController.text.trim(),
                      "City": cityController.text.trim(),
                      "State": stateController.text.trim(),
                      "Pincode": pinController.text.trim(),
                    };

                    context
                        .read<CheckoutProvider>()
                        .setAddress(addressData);

                    showSuccess();
                  }
                },
                child: const Text(
                  "Save Address",
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
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
        TextEditingController? controller,
        TextInputType keyboard = TextInputType.text,
        String? Function(String?)? validator,
        bool required = true,

        //  CHANGED: Added to support mobile formatter
        List<TextInputFormatter>? inputFormatters,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,

        //CHANGED: Applied only when provided
        inputFormatters: inputFormatters,

        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon:
          Icon(icon, color: const Color(0xFF6A3CBC), size: 20),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator:
        required ? validator ?? (v) => v!.isEmpty ? "Required" : null : null,
      ),
    );
  }
}
