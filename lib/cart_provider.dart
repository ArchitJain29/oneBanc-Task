import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, Map<String, dynamic>> _cartItems =
      {}; // {dishId: {name, price, image, quantity}}
  final List<Map<String, dynamic>> _previousOrders = [];

  Map<String, Map<String, dynamic>> get cartItems => _cartItems;
  List<Map<String, dynamic>> get previousOrders => _previousOrders;

  void addToCart(String dishId, String dishName, double price, String image) {
    if (_cartItems.containsKey(dishId)) {
      // _cartItems[dishId]!['quantity']++;
      _cartItems[dishId]!['quantity'] =
          (_cartItems[dishId]!['quantity'] ?? 0) + 1;
    } else {
      _cartItems[dishId] = {
        'name': dishName,
        'quantity': 1,
        'price': price,
        'image': image,
      };
    }
    notifyListeners();
  }

  void updateCartItem(String dishId, int quantity) {
    if (_cartItems.containsKey(dishId)) {
      if (quantity > 0) {
        _cartItems[dishId]!['quantity'] = quantity;
      } else {
        _cartItems.remove(dishId);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String dishId) {
    if (_cartItems.containsKey(dishId)) {
      _cartItems.remove(dishId);
      notifyListeners();
    }
  }

  void placeOrder() {
    if (_cartItems.isNotEmpty) {
      double totalPrice = _cartItems.entries.fold(0,
          (sum, item) => sum + (item.value['price'] * item.value['quantity']));

      double cgst = totalPrice * 0.025;
      double sgst = totalPrice * 0.025;
      double finalAmount = totalPrice + cgst + sgst;

      _previousOrders.insert(0, {
        'id': const Uuid().v4(),
        'dateTime': DateTime.now().toString(),
        'amount': finalAmount.toStringAsFixed(2),
      });

      clearCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
