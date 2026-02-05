import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import 'address_form_sheet.dart';
import 'address_confirm_screen.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cartCount = context.watch<CartProvider>().itemCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      //  CURVED APP BAR WITH CART
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A3CBC),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
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

      body: Column(
        children: [
          // 🖼️ IMAGE CAROUSEL
          SizedBox(
            height: 300,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  itemCount: product.images.length,
                  onPageChanged: (index) {
                    setState(() => currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.network(
                          product.images[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),

                // 🔵 DOT INDICATOR
                Positioned(
                  bottom: 12,
                  child: Row(
                    children: List.generate(
                      product.images.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin:
                        const EdgeInsets.symmetric(horizontal: 4),
                        width: currentIndex == index ? 14 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? const Color(0xFF6A3CBC)
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 📄 DETAILS
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              "${product.rating}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Reviews available",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A3CBC),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Product Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🛒 STICKY BOTTOM BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  context.read<CartProvider>().addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Product added to cart"),
                    ),
                  );
                },
                child: const Text("Add to Cart"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A3CBC),
                  foregroundColor: Colors.white, // ⭐ IMPORTANT FIX
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  final checkout =
                  context.read<CheckoutProvider>();

                  checkout.setOrder(
                    [product],
                    product.price,
                  );

                  if (checkout.hasAddress) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const AddressConfirmScreen(),
                      ),
                    );
                  } else {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) =>
                      const AddressFormSheet(),
                    );
                  }
                },
                child: const Text("Buy Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
