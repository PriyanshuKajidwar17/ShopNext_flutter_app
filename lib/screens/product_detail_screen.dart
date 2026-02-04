import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import 'buy_now_screen.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          // 🖼️ IMAGE CAROUSEL
          SizedBox(
            height: 280,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: product.images.length,
                  onPageChanged: (index) {
                    setState(() => currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.network(
                          product.images[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),

                // ◀ ▶ ARROWS
                Positioned(
                  left: 8,
                  top: 120,
                  child: Icon(Icons.arrow_back_ios),
                ),
                Positioned(
                  right: 8,
                  top: 120,
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),

          // 🔵 DOT INDICATOR
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              product.images.length,
                  (index) => Container(
                margin: const EdgeInsets.all(4),
                width: currentIndex == index ? 10 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? Colors.deepPurple
                      : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ TITLE
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ⭐ RATING
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(
                        "${product.rating} / 5",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      const Text("(Reviews available)"),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 💰 PRICE
                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 📄 DESCRIPTION
                  const Text(
                    "Product Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const Spacer(),

                  // 🛒 BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context
                                .read<CartProvider>()
                                .addToCart(product);

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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BuyNowScreen(),
                              ),
                            );
                          },
                          child: const Text("Buy Now"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
