// import 'package:flutter/material.dart';
// import 'package:tas/api_service.dart';
// import 'package:tas/screens/cuisine_details_screen.dart';

// class FilterScreen extends StatefulWidget {
//   const FilterScreen({super.key});

//   @override
//   State<FilterScreen> createState() => _FilterScreenState();
// }

// class _FilterScreenState extends State<FilterScreen> {
//   List<String> cuisineOptions = [];
//   String? selectedCuisine;
//   double minPrice = 0;
//   double maxPrice = 500;
//   List<dynamic> filteredCuisines = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     loadCuisineTypes();
//   }

//   Future<void> loadCuisineTypes() async {
//     try {
//       final types = await ApiService.fetchCuisineTypes();
//       setState(() {
//         cuisineOptions = types;
//       });
//     } catch (e) {
//       print("Error loading cuisine types: $e");
//     }
//   }

//   Future<void> applyFilters() async {
//     setState(() => isLoading = true);
//     try {
//       final data = await ApiService.filterCuisines(
//         cuisineType: selectedCuisine != null ? [selectedCuisine!] : null,
//         minAmount: minPrice.toInt(),
//         maxAmount: maxPrice.toInt(),
//       );
//       setState(() {
//         filteredCuisines = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error applying filters: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Filter Dishes'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DropdownButtonFormField<String>(
//               value: selectedCuisine,
//               hint: const Text('Select Cuisine'),
//               items: cuisineOptions.map((cuisine) {
//                 return DropdownMenuItem(
//                   value: cuisine,
//                   child: Text(cuisine),
//                 );
//               }).toList(),
//               onChanged: (value) => setState(() => selectedCuisine = value),
//             ),
//             const SizedBox(height: 16),
//             Text('Price Range: \$${minPrice.toInt()} - \$${maxPrice.toInt()}'),
//             RangeSlider(
//               values: RangeValues(minPrice, maxPrice),
//               min: 0,
//               max: 1000,
//               divisions: 20,
//               labels: RangeLabels(
//                 '\$${minPrice.toInt()}',
//                 '\$${maxPrice.toInt()}',
//               ),
//               onChanged: (range) {
//                 setState(() {
//                   minPrice = range.start;
//                   maxPrice = range.end;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: applyFilters,
//               child: const Text('Apply Filters'),
//             ),
//             const SizedBox(height: 16),
//             if (isLoading)
//               const Center(child: CircularProgressIndicator())
//             else if (filteredCuisines.isEmpty)
//               const Center(child: Text("No cuisines found."))
//             else
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: filteredCuisines.length,
//                   itemBuilder: (context, index) {
//                     final cuisine = filteredCuisines[index];
//                     return Card(
//                       child: ListTile(
//                         leading: Image.network(
//                           cuisine['cuisine_image_url'] ?? '',
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Icon(Icons.image_not_supported),
//                         ),
//                         title: Text(cuisine['cuisine_name'] ?? ''),
//                         subtitle:
//                             Text("${(cuisine['items'] as List).length} dishes"),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => CuisineDetailsScreen(
//                                 cuisine: cuisine,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
