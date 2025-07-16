// lib/pages/search_page.dart - UPDATED to connect with restaurant data

import 'package:flutter/material.dart';
import 'package:hellodekal/components/my_textfield.dart';
import 'package:hellodekal/pages/category_results_page.dart';
import 'package:hellodekal/pages/food_page.dart';
import 'package:hellodekal/pages/menu_page.dart'; // ← ADD THIS IMPORT
import 'package:hellodekal/models/food.dart'; // ← ADD THIS IMPORT
import 'package:hellodekal/models/restaurant.dart'; // ← ADD THIS IMPORT
import 'package:provider/provider.dart'; // ← ADD THIS IMPORT

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'V1 Cafe', 
      'icon': Icons.restaurant,
      'displayName': 'V1 Cafe',
      'category': FoodCategory.v1,
      'description': 'Aassorted Malay dishes'
    },
    {
      'name': 'V2 Cafe ', 
      'icon': Icons.fastfood,
      'displayName': 'V2 Cafe',
      'category': FoodCategory.v2,
      'description': 'Quick bites'
    },
    {
      'name': 'V3 Cafe', 
      'icon': Icons.rice_bowl,
      'displayName': 'V3 Cafe',
      'category': FoodCategory.v3,
      'description': 'Chinese Cuisine'
    },
    {
      'name': 'V4 Cafe', 
      'icon': Icons.local_pizza,
      'displayName': 'V4 Cafe',
      'category': FoodCategory.v4,
      'description': 'Noodles and sweet treats'
    },
    {
      'name': 'V5 Cafe', 
      'icon': Icons.cake,
      'displayName': 'V5 Cafe',
      'category': FoodCategory.v5,
      'description': 'Mixed variety'
    },
    {
      'name': 'V6 Cafe', 
      'icon': Icons.lunch_dining,
      'displayName': 'V6 Cafe',
      'category': FoodCategory.v6,
      'description': 'Flavorful Fried Rice'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Cart icon
          Consumer<Restaurant>(
            builder: (context, restaurant, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.black),
                    onPressed: () {
                      Navigator.pushNamed(context, '/orders');
                    },
                  ),
                  if (restaurant.getTotalItemCount() > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${restaurant.getTotalItemCount()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Food, Cafe, etc.',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          // Show search results or categories
          Expanded(
            child: searchQuery.isEmpty 
                ? _buildCategoriesView() 
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  // ✅ Categories view (when no search)
  Widget _buildCategoriesView() {
    return Column(
      children: [
        // Categories title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Categories grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.0,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Consumer<Restaurant>(
                  builder: (context, restaurant, child) {
                    // Count items in this category
                    final itemCount = restaurant.menu
                        .where((food) => food.category == category['category'])
                        .length;

                    return GestureDetector(
                      onTap: () {
                        // ✅ Navigate to MenuPage for this category
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuPage(
                              restaurantName: category['displayName'],
                              category: category['category'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category['icon'],
                              size: 40,
                              color: const Color(0xFF002D72),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              category['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category['description'],
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$itemCount items',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF002D72),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Search results view
  Widget _buildSearchResults() {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        // Filter foods based on search query
        final searchResults = restaurant.menu.where((food) {
          return food.name.toLowerCase().contains(searchQuery) ||
                 food.description.toLowerCase().contains(searchQuery) ||
                 food.category.displayName.toLowerCase().contains(searchQuery);
        }).toList();

        if (searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try searching for "$searchQuery" with different keywords',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Results header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Search Results (${searchResults.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Results list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final food = searchResults[index];
                  return SearchResultCard(food: food);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ✅ Search Result Card Widget
class SearchResultCard extends StatelessWidget {
  final Food food;

  const SearchResultCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to FoodPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodPage(food: food),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Food image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: Image.asset(
                food.imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.fastfood, size: 30),
                  );
                },
              ),
            ),
            // Food details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${food.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF002D72),
                          ),
                        ),
                        Text(
                          food.category.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}