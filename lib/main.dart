import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/checkout_provider.dart';
import 'providers/order_provider.dart';
import 'providers/payment_provider.dart';

import 'screens/home_screen.dart';
import 'screens/auth/phone_login_screen.dart';
import 'utils/auth_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('cartBox');
  await Hive.openBox('addressBox');
  await Hive.openBox('orderBox');
  await Hive.openBox('authBox');
  await Hive.openBox('paymentBox'); // ✅ NEW

  runApp(const ShopNext());
}

class ShopNext extends StatelessWidget {
  const ShopNext({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()..loadCart()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()..loadAddress()),
        ChangeNotifierProvider(create: (_) => OrderProvider()..loadOrders()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()), // ✅ NEW
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ShopNext',
        theme: ThemeData(
          primaryColor: const Color(0xFF2874F0),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2874F0),
            foregroundColor: Colors.white,
          ),
        ),
        home: AuthHelper.isLoggedIn()
            ? const HomeScreen()
            : const PhoneLoginScreen(),
      ),
    );
  }
}
