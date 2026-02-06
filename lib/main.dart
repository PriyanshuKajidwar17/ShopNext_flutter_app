import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/checkout_provider.dart';
import 'providers/order_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ INIT HIVE
  await Hive.initFlutter();

  // ✅ OPEN BOXES
  await Hive.openBox('cartBox');
  await Hive.openBox('addressBox');
  await Hive.openBox('orderBox');

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ShopNext',
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
