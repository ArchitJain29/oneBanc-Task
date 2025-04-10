import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tas/cart_provider.dart';
import 'package:tas/screens/place_order_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems.entries.map((entry) {
      return {
        'id': entry.key, // ✅ Keep ID for operations
        'name': entry.value['name'], // ✅ Use the correct dish name
        'quantity': entry.value['quantity'],
        'price': entry.value['price'],
        'image': entry.value['image'],
      };
    }).toList();

    // Price Calculations
    double totalPrice = cartItems.fold(
        0, (sum, item) => sum + (item['price'] * (item['quantity'] ?? 1)));
    double cgst = totalPrice * 0.025;
    double sgst = totalPrice * 0.025;
    double finalAmount = totalPrice + cgst + sgst;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Your Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Orders',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Cart Items List
            Expanded(
              child: cartItems.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset('assets/empty_cart.png', height: 120),
                        // const SizedBox(height: 10),
                        Center(
                          child: const Text(
                            'Your cart is empty!',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['image'],
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item['name'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              "₹${item['price'].toStringAsFixed(2)} each",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            trailing: Container(
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove,
                                        color: Colors.orange),
                                    // onPressed: () {
                                    //   if (item['quantity'] > 1) {
                                    //     cartProvider.updateCartItem(
                                    //         item['name'], item['quantity'] - 1);
                                    //   } else {
                                    //     cartProvider
                                    //         .removeFromCart(item['name']);
                                    //   }
                                    // },
                                    onPressed: () {
                                      if (item['quantity'] > 1) {
                                        cartProvider.updateCartItem(
                                            item['id'], item['quantity'] - 1);
                                      } else {
                                        cartProvider.removeFromCart(item['id']);
                                      }
                                    },
                                  ),
                                  Text(
                                    item['quantity'].toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  IconButton(
                                      icon: const Icon(Icons.add,
                                          color: Colors.orange),
                                      onPressed: () {
                                        cartProvider.updateCartItem(
                                            item['id'], item['quantity'] + 1);
                                      }),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),

            // Bill Summary
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRow(
                      "Subtotal:", "₹${totalPrice.toStringAsFixed(2)}"),
                  _buildPriceRow("CGST (2.5%):", "₹${cgst.toStringAsFixed(2)}"),
                  _buildPriceRow("SGST (2.5%):", "₹${sgst.toStringAsFixed(2)}"),
                  const Divider(),
                  _buildPriceRow(
                    "Total Amount:",
                    "₹${finalAmount.toStringAsFixed(2)}",
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Checkout Button
            AnimatedOpacity(
              opacity: cartItems.isEmpty ? 0.5 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: cartItems.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    PlaceOrderScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      cartItems.isEmpty ? Colors.grey : Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Center(
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: isTotal ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
