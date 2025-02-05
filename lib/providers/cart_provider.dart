import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  // A map to store cart items, where the key is the product ID
  final Map<int, Map<String, dynamic>> _cartItems = {};

  // Getter to access cart items
  Map<int, Map<String, dynamic>> get cartItems => _cartItems;

  // Add product to cart
  void addToCart(Map<String, dynamic> product) {
    if (_cartItems.containsKey(product['product_id'])) {
      _cartItems[product['product_id']]!['quantity']++;
    } else {
      _cartItems[product['product_id']] = {
        'image': product['image'],
        'name': product['name'],
        'price': product['price'],
        'quantity': 1,
      };
    }
    notifyListeners(); // Notify listeners that the cart has changed
  }

  // Update quantity of a product
  void updateQuantity(int productId, int delta) {
    if (_cartItems.containsKey(productId)) {
      final currentQuantity = _cartItems[productId]!['quantity'];
      if (currentQuantity + delta > 0) {
        _cartItems[productId]!['quantity'] = currentQuantity + delta;
        notifyListeners(); // Notify listeners that the cart has changed
      }
    }
  }

  // Remove product from cart
  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    notifyListeners(); // Notify listeners that the cart has changed
  }
}
