class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final double rating;
  final List<String> images;
  final String category; // ✅ REQUIRED FOR CATEGORY FILTER

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.rating,
    required this.images,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      rating: (json['rating'] as num).toDouble(),
      images: List<String>.from(json['images']),
      category: json['category'], // ✅ FROM API
    );
  }
}
