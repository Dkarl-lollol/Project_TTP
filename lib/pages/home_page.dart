import 'package:flutter/material.dart';
import 'package:hellodekal/pages/cart_page.dart';
import 'package:hellodekal/pages/menu_page.dart';
import 'package:hellodekal/pages/order_page.dart';
import 'package:hellodekal/pages/search_page.dart';
import 'package:hellodekal/pages/profile_page.dart';
import 'package:hellodekal/pages/food_page.dart';
import 'package:hellodekal/components/category_chip.dart';
import 'package:hellodekal/components/restaurant_card.dart';
import 'package:hellodekal/models/food.dart';
import 'package:hellodekal/models/restaurant.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const SearchPage(),
    const OrdersPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF002D72),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white70,
        elevation: 8,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String currentLocation = "V5A";
  final TextEditingController _locationController = TextEditingController();

  // Sample location suggestions
  final List<String> _locationSuggestions = [
    'V1B',
    'V2A',
    'V3C',
    'V5B',
  ];

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                const Text(
                  'Set Pickup Location',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Search field
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Enter address or postal code',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF4A90E2)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF4A90E2)),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        currentLocation = value;
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 20),
                // Current location option
                ListTile(
                  leading: const Icon(Icons.my_location, color: Color(0xFF4A90E2)),
                  title: const Text('Use current location'),
                  subtitle: const Text('Automatically detect your location'),
                  onTap: () {
                    setState(() {
                      currentLocation = "Current Location";
                    });
                    Navigator.pop(context);
                    // TODO: Implement actual location detection
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Location detection coming soon!')),
                    );
                  },
                ),
                const Divider(),
                // Location suggestions
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Suggested Locations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _locationSuggestions.length,
                    itemBuilder: (context, index) {
                      final location = _locationSuggestions[index];
                      return ListTile(
                        leading: Icon(
                          location.contains('Campus') ? Icons.school :
                          location == 'Home' ? Icons.home :
                          location == 'Work' ? Icons.work :
                          Icons.location_on,
                          color: const Color(0xFF4A90E2),
                        ),
                        title: Text(location),
                        onTap: () {
                          setState(() {
                            currentLocation = location;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToRestaurantMenu(BuildContext context, String restaurantName) {
    final restaurant = Provider.of<Restaurant>(context, listen: false);
    final foods = restaurant.menu;
    
    if (foods.isNotEmpty) {
      Navigator.push(
        context,
      MaterialPageRoute(
          builder: (context) => FoodPage(food: foods.first),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$restaurantName menu coming soon!')),
      );
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: _showLocationPicker,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on,
                color: Color(0xFF4A90E2),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                currentLocation,
                style: const TextStyle(
                  color: Color(0xFF4A90E2),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF4A90E2),
                size: 20,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
          Consumer<Restaurant>(
            builder: (context, restaurant, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartPage()),
                      );
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
            // Restaurant cards with navigation
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  GestureDetector(
                    onTap: () => _navigateToRestaurantMenu(context, 'V3 Cafe'),
                    child: RestaurantCard(
                      name: 'V3 Cafe',
                      rating: 4.9,
                      reviews: 103,
                      distance: '0.2km',
                      time: '10 min',
                      image: 'lib/images/v3/v3cafe.jpeg',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToRestaurantMenu(context, 'V5 Cafe'),
                    child: RestaurantCard(
                      name: 'V5 Cafe',
                      rating: 4.8,
                      reviews: 561,
                      distance: '0.1km',
                      time: '8 min',
                      image: 'lib/images/v5/v5cafe.jpeg',
                    ),
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
            // Additional restaurant cards with navigation
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  GestureDetector(
                    onTap: () => _navigateToRestaurantMenu(context, 'V1 Cafe'),
                    child: RestaurantCard(
                      name: 'V1 Cafe',
                      rating: 4.7,
                      reviews: 89,
                      distance: '0.3km',
                      time: '5 min',
                      image: 'lib/images/v1/v1cafe.jpeg',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToRestaurantMenu(context, 'V2 Cafe'),
                    child: RestaurantCard(
                      name: 'V2 Cafe',
                      rating: 4.6,
                      reviews: 234,
                      distance: '0.4km',
                      time: '12 min',
                      image: 'lib/images/v2/v2cafe.jpeg',
                    ),
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