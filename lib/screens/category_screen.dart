import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tas/cart_provider.dart';

class CategoryScreen extends StatelessWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final Map<String, List<Map<String, dynamic>>> categoryDishes = {
      'Indian': [
        {
          'id': 'dal_makhni',
          'name': 'Dal Makhni',
          'image':
              'https://media.istockphoto.com/id/1170374719/photo/dal-makhani-at-dark-background.jpg?s=612x612&w=0&k=20&c=49yLaUAE2apakVk2AAiRQimZd98WtSjIQ0hzCzWsmns=',
          'price': 250.0,
          'rating': 4.8,
        },
        {
          'id': 'chole_bhature',
          'name': 'Chole Bhature',
          'image':
              'https://www.shutterstock.com/image-photo/chole-bhature-north-indian-food-600nw-2238261205.jpg',
          'price': 180.0,
          'rating': 4.7,
        },
      ],
      'Chinese': [
        {
          'id': 'manchurian',
          'name': 'Manchurian',
          'image':
              'https://t3.ftcdn.net/jpg/04/47/95/48/360_F_447954890_nYoJ3Lm6OElMe0LogDry2KfHF4tXsfMw.jpg',
          'price': 200.0,
          'rating': 4.6,
        },
        {
          'id': 'chowmein',
          'name': 'Chowmein',
          'image':
              'https://media.istockphoto.com/id/483137365/photo/asian-chow-mein-noodles.jpg?s=612x612&w=0&k=20&c=aVkPKpDkiAM7CxTFinQBax0i-nm-ybzWimrJRyPePcg=',
          'price': 150.0,
          'rating': 4.5,
        },
      ],
    };

    final dishes = categoryDishes[category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title:
            Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: dishes.isEmpty
          ? const Center(child: Text("No dishes available for this category!"))
          : ListView.builder(
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                final dish = dishes[index];
                int quantity =
                    cartProvider.cartItems[dish['id']]?['quantity'] ?? 0;

                return Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    int quantity =
                        cartProvider.cartItems[dish['id']]?['quantity'] ?? 0;

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: Image.network(dish['image'],
                            width: 60, height: 60, fit: BoxFit.cover),
                        title: Text(dish['name']),
                        subtitle:
                            Text("₹${dish['price']} | ⭐ ${dish['rating']}"),
                        trailing: quantity > 0
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove,
                                        color: Colors.red),
                                    onPressed: () {
                                      cartProvider.removeFromCart(dish['id']);
                                    },
                                  ),
                                  Text(quantity.toString(),
                                      style: const TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Colors.green),
                                    onPressed: () {
                                      cartProvider.addToCart(
                                          dish['id'],
                                          dish['name'],
                                          dish['price'],
                                          dish['image']);
                                    },
                                  ),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  cartProvider.addToCart(
                                      dish['id'],
                                      dish['name'],
                                      dish['price'],
                                      dish['image']);
                                },
                                child: const Text("Add"),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
