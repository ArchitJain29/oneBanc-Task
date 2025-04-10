import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:tas/cart_provider.dart';
import 'package:tas/dishcard.dart';
import 'package:tas/screens/cart_screen.dart';
import 'package:tas/screens/cuisine_details_screen.dart';
import 'package:tas/api_service.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> cuisines = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCuisines();
  }

  Future<void> fetchCuisines() async {
    try {
      final data = await ApiService.fetchCuisines();
      setState(() {
        cuisines = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching cuisines: $e");
      setState(() => isLoading = false);
    }
  }

  final List<Map<String, dynamic>> topDishes = [
    {
      'name': 'Kadai Paneer',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2qUrNdPUtWIj8z3VfFOAsVGQE2izLTiZnsQ&s',
      'price': 230.0,
      'rating': 4.5,
    },
    {
      'name': 'Pasta Alfredo',
      'image':
          'https://www.shutterstock.com/image-photo/vegan-alfredo-pasta-creamy-cashewbased-600nw-2509493569.jpg',
      'price': 300.00,
      'rating': 4.7,
    },
    {
      'name': 'Tacos',
      'image':
          'https://media.istockphoto.com/id/542331706/photo/homemade-spicy-shrimp-tacos.jpg?s=612x612&w=0&k=20&c=fxx5deD9YgseQfLc3IFZpoMfwdq8Fb7jYimAjITs6TA=',
      'price': 200.00,
      'rating': 4.6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        shadowColor: const Color.fromARGB(255, 187, 185, 185),
        backgroundColor: Colors.white,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              int totalItems = cart.cartItems.values.fold(0, (sum, item) {
                return sum + (item['quantity'] as int);
              });
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CartScreen()),
                      );
                    },
                  ),
                  if (totalItems > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.deepOrange,
                        child: Text(
                          totalItems.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: CarouselSlider.builder(
                  itemCount: 3,
                  itemBuilder: (context, index, realIndex) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(12),
                          height: 20,
                          width: 120,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                  options: CarouselOptions(
                    height: 300,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    viewportFraction: 1.0,
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Cuisines',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 300,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                      ),
                      items: cuisines.map((cuisine) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CuisineDetailsScreen(cuisine: cuisine),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image:
                                    NetworkImage(cuisine['cuisine_image_url']),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Text(
                                      cuisine['cuisine_name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Top Dishes',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: topDishes.length,
                      itemBuilder: (context, index) {
                        final dish = topDishes[index];
                        return DishCard(
                          name: dish['name'],
                          image: dish['image'],
                          price: dish['price'],
                          rating: dish['rating'],
                          onAddToCart: () {},
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
