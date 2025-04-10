import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _url =
      "https://uat.onebanc.ai/emulator/interview/get_item_list";
  static const Map<String, String> _headers = {
    "X-Partner-API-Key": "uonebancservceemultrS3cg8RaL30",
    "X-Forward-Proxy-Action": "get_item_list",
    "Content-Type": "application/json",
  };

  static Future<List<dynamic>> fetchCuisines() async {
    List<dynamic> allCuisines = [];
    int currentPage = 1;
    int totalPages = 1;

    try {
      do {
        final response = await http.post(
          Uri.parse(_url),
          headers: _headers,
          body: jsonEncode({"page": currentPage, "count": 10}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (currentPage == 1) {
            totalPages =
                data['total_pages']; // Get total pages from first request
          }

          allCuisines.addAll(data['cuisines'] ?? []);
          currentPage++;
        } else {
          throw Exception("Failed to load cuisines");
        }
      } while (currentPage <= totalPages); // Loop until we get all pages

      return allCuisines;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
