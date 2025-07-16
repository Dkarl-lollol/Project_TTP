import 'package:flutter/material.dart';
import 'package:hellodekal/components/category_chip.dart';
import 'package:hellodekal/components/restaurant_card.dart';
import 'package:hellodekal/pages/search_page.dart';
//

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(
              Icons.location_on,
              color: Color(0xFF4A90E2),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'V5A',
              style: TextStyle(
                color: Color(0xFF4A90E2),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              // TODO: Navigate to cart
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 12),
                      const Text(
                        'Food, Cafe, etc.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Categories
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  CategoryChip(
                    icon: Icons.star,
                    label: 'Favourite',
                    color: const Color(0xFFE3F2FD),
                  ),
                  CategoryChip(
                    icon: Icons.eco,
                    label: 'Healthy',
                    color: const Color(0xFFE8F5E8),
                  ),
                  CategoryChip(
                    icon: Icons.lunch_dining,
                    label: 'Western',
                    color: const Color(0xFFFFF3E0),
                  ),
                  CategoryChip(
                    icon: Icons.rice_bowl,
                    label: 'Asian',
                    color: const Color(0xFFFCE4EC),
                  ),
                  CategoryChip(
                    icon: Icons.fastfood,
                    label: 'Fast Food',
                    color: const Color(0xFFE1F5FE),
                  ),
                ],
              ),
            ),
            // Student's Choice Section
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Student\'s Choice',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Restaurant cards
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  RestaurantCard(
                    name: 'V3 Cafe',
                    rating: 4.9,
                    reviews: 103,
                    distance: '0.2km',
                    time: '10 min',
                    image: 'lib/images/v3/v3_food.jpg',
                  ),
                  RestaurantCard(
                    name: 'V5 Cafe',
                    rating: 4.8,
                    reviews: 561,
                    distance: '0.1km',
                    time: '8 min',
                    image: 'lib/images/v5/v5_food.jpg',
                  ),
                ],
              ),
            ),
            // Fastest Section
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Fastest',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Additional restaurant cards
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  RestaurantCard(
                    name: 'V1 Cafe',
                    rating: 4.7,
                    reviews: 89,
                    distance: '0.3km',
                    time: '5 min',
                    image: 'lib/images/v1/v1_food.jpg',
                  ),
                  RestaurantCard(
                    name: 'V2 Cafe',
                    rating: 4.6,
                    reviews: 234,
                    distance: '0.4km',
                    time: '12 min',
                    image: 'lib/images/v2/v2_food.jpg',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}