ShopNext: E-Commerce Application

ShopNext is a modern Flutter-based e-commerce mobile application developed using Dart and Flutter. The application allows users to browse products, view detailed product information, add products to a shopping cart, and calculate the total bill.

The app uses the DummyJSON REST API to fetch product data and Provider for state management.


# Features

* Modern home screen
* Product listing in a 2-column grid
* Product details screen
* Product image carousel
* Product ratings
* Product descriptions
* Add products to cart
* Remove products from cart
* Automatic cart total calculation
* Dynamic product loading
* Hero animation for product images
* Loading indicators
* Image loading error handling
* Add-to-cart popup
* Buy Now flow with progress screen
* Responsive Flutter UI

---

# Technologies Used

* Flutter – Application development
* Dart – Programming language
* Provider – State management
* REST API – Fetching product data
* DummyJSON – Product data source
* Git – Version control
* GitHub – Source code hosting

---
# Data Source
  ShopNext currently uses the DummyJSON Products API to retrieve product information.
  API: https://dummyjson.com/products

# The application receives product information such as:

* Product ID
* Product title
* Price
* Description
* Rating
* Product images

# Data Flow
ShopNext Flutter App
        ↓
   HTTP Request
        ↓
 DummyJSON REST API
        ↓
   Product JSON
        ↓
 ProductProvider
        ↓
    Product UI

Note: ShopNext currently does not use its own backend database. Product data is fetched from DummyJSON.


# Data Storage

# Product Data
  Product data is retrieved from the DummyJSON API and is not permanently stored in a ShopNext database.

# Cart Data
  Cart information is currently managed using Provider during application runtime.

Product
   ↓
ProductProvider
   ↓
Add to Cart
   ↓
CartProvider
   ↓
Cart Screen
   ↓
Total Amount

# Project Architecture
  The project follows a basic separation of models, providers, screens, and reusable widgets.


lib/
│
├── models/
│   └── product.dart
│
├── providers/
│   ├── product_provider.dart
│   └── cart_provider.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── product_detail_screen.dart
│   ├── cart_screen.dart
│   └── ...
│
├── widgets/
│   └── product_card.dart
│
└── main.dart

# Product Loading

ShopNext initially loads 12 products from the API.
When the user selects "Reveal More", additional products are loaded.

Initial Load
     ↓
12 Products
     ↓
User clicks "Reveal More"
     ↓
Additional Products
     ↓
Update Product List


Product loading is managed by ProductProvider.


# Cart Management
  The application uses CartProvider to manage shopping-cart operations.

Users can:

* Add products
* Remove products
* View cart items
* Calculate the total price

Example:
Product A → ₹100
Product B → ₹200
Product C → ₹150
------------------
Total     → ₹450

# User Interface
The application focuses on a simple and user-friendly shopping experience.

Main screens include:

# Home Screen
Displays available products in a two-column grid.

# Product Details
Displays:
* Product images
* Product name
* Price
* Rating
* Description
* Add to Cart option
* Buy Now option

# Cart Screen
Displays:
* Selected products
* Product quantity/details
* Remove option
* Total bill
  
# Getting Started

# Prerequisites

Make sure you have installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android Emulator or physical Android device
* Git

Check your Flutter installation:

bash
flutter doctor

# Installation

# 1. Clone the Repository

bash
git clone https://github.com/PriyanshuKajidwar17/ShopNext_flutter_app.git

# 2. Open the Project

bash
cd ShopNext_flutter_app

# 3. Install Dependencies

bash
flutter pub get

# 4. Run the Application

bash
flutter run

# Run as Flutter Web
To run the project in a browser:

bash
flutter run -d chrome

To create a production web build:

bash
flutter build web --release

# Build Android APK
To generate a release APK:

bash
flutter build apk --release


The generated APK can be found inside:
build/app/outputs/flutter-apk/


# Future Improvements

The following features can be added in future versions:

* User authentication
* User profile
* Wishlist
* Product search
* Product categories and filters
* Order history
* Online payment integration
* Custom backend
* Permanent database
* Push notifications
* Address management
* Admin dashboard


# Repository

GitHub Repository:
  https://github.com/PriyanshuKajidwar17/ShopNext_flutter_app

# Developer
  Priyanshu Kamlesh Kajidwar

# License
  This project is created for educational and portfolio purposes.
