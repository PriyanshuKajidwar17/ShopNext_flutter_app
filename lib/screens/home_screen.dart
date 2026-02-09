import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final categories = [
    "All",
    "Mobiles",
    "Fashion",
    "Electronics",
    "Shoes",
  ];

  int selectedCategory = 0;

  late AnimationController _bikeController;
  late Animation<double> _bikeAnimation;

  // 🔴 CHANGED: ScrollController for infinite scroll
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<ProductProvider>().loadInitialProducts();

    // 🚴 Bike animation ONLY for icon
    _bikeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bikeAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(
        parent: _bikeController,
        curve: Curves.easeInOut,
      ),
    );

    // 🔴 CHANGED: Listen when user reaches end of list
    _scrollController.addListener(() {
      final provider = context.read<ProductProvider>();

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoading) {
        provider.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _bikeController.dispose();

    // 🔴 CHANGED: Dispose controller
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;
    final cartCount = context.watch<CartProvider>().itemCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      // 🟣 APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A3CBC),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "ShopNext",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            AnimatedBuilder(
              animation: _bikeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_bikeAnimation.value, 0),
                  child: child,
                );
              },
              child: Row(
                children: const [
                  Icon(Icons.directions_bike,
                      color: Colors.white, size: 20),
                  SizedBox(width: 3),
                  Icon(Icons.shopping_bag,
                      color: Colors.white, size: 14),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderHistoryScreen(),
                ),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon:
                const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartScreen(),
                    ),
                  );
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartCount.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A3CBC),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // 🧱 BODY
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) {
                  context.read<ProductProvider>().search(value);
                },
                decoration: const InputDecoration(
                  hintText: "Search products",
                  prefixIcon: Icon(Icons.search, size: 20),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // 🏷️ CATEGORY PILLS
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final isSelected = index == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedCategory = index);
                    context
                        .read<ProductProvider>()
                        .setCategory(categories[index]);
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF6A3CBC)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF6A3CBC)
                            : Colors.grey.shade300,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 🛍️ PRODUCTS GRID (INFINITE SCROLL)
          Expanded(
            child: GridView.builder(
              controller: _scrollController, //
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length +
                  (productProvider.isLoading ? 2 : 0),
              itemBuilder: (context, index) {
                if (index >= products.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ProductCard(product: products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
