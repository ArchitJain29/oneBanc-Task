import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tas/cart_provider.dart';

class PlaceOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems.entries.map((entry) {
      return {
        'name': entry.value['name'], // ✅ Corrected: Get name from value
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Confirm Your Order",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Order Items List
            Expanded(
              child: cartItems.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/empty_cart.png', height: 120),
                        const SizedBox(height: 10),
                        const Text(
                          'No items in the order!',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(10),
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
                              "Qty: ${item['quantity']}  |  Price: ₹${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),

            // Price Details
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

            // Place Order Button
            ElevatedButton(
              onPressed: cartItems.isEmpty
                  ? null
                  : () {
                      cartProvider.placeOrder();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Order Placed Successfully!')),
                      );
                      Navigator.pop(context);
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
                  'Place Order',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
