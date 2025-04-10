import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tas/cart_provider.dart';

class CuisineDetailsScreen extends StatelessWidget {
  final dynamic cuisine;

  const CuisineDetailsScreen({super.key, required this.cuisine});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cuisine['cuisine_name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: cuisine['items'].length,
          itemBuilder: (context, index) {
            final dish = cuisine['items'][index];
            int quantity = cartProvider.cartItems[dish['id']]?['quantity'] ?? 0;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              shadowColor: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        dish['image_url'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dish['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${dish['price']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                dish['rating'].toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    quantity > 0
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.orange),
                            ),
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 0.6, vertical: 0.3),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // IconButton(
                                //   icon: const Icon(Icons.remove, size: 20),
                                //   onPressed: () {
                                //     cartProvider.removeFromCart(dish['id']);
                                //   },
                                //   color: Colors.deepOrange,
                                //   splashRadius: 20,
                                // ),
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 20),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      cartProvider.updateCartItem(
                                          dish['id'], quantity - 1);
                                    } else {
                                      cartProvider.removeFromCart(dish['id']);
                                    }
                                  },
                                  color: Colors.deepOrange,
                                  splashRadius: 20,
                                ),

                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 20),
                                  onPressed: () {
                                    cartProvider.addToCart(
                                      dish['id'],
                                      dish['name'],
                                      double.tryParse(
                                              dish['price'].toString()) ??
                                          0.0,
                                      dish['image_url'],
                                    );
                                  },
                                  color: Colors.deepOrange,
                                  splashRadius: 20,
                                ),
                              ],
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              cartProvider.addToCart(
                                dish['id'],
                                dish['name'],
                                double.tryParse(dish['price'].toString()) ??
                                    0.0,
                                dish['image_url'],
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: const Text("Add to Cart"),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
