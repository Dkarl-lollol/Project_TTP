import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hellodekal/components/order_status_item.dart';
import 'package:hellodekal/models/order_status.dart';
import 'package:hellodekal/models/restaurant.dart';
import 'package:provider/provider.dart';

class OrderPreparationPage extends StatefulWidget {
  final String? orderId;
  
  const OrderPreparationPage({super.key, this.orderId});

  @override
  State<OrderPreparationPage> createState() => _OrderPreparationPageState();
}

class _OrderPreparationPageState extends State<OrderPreparationPage> {
  late GoogleMapController mapController;
  OrderStatus currentStatus = OrderStatus.cooking;
  
  final LatLng _center = const LatLng(52.5200, 13.4050); // Berlin coordinates as shown in Figma

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
          'Order Tracking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Map section
          Container(
            height: 300,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('restaurant'),
                  position: _center,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  infoWindow: const InfoWindow(
                    title: 'Restaurant Location',
                  ),
                ),
              },
            ),
          ),
          // Order status section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Arrives in 25-30 min',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Status title
                  const Text(
                    'Preparing your order',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Status timeline
                  Expanded(
                    child: Column(
                      children: [
                        OrderStatusItem(
                          icon: Icons.check_circle,
                          title: 'Order received',
                          isCompleted: true,
                          isActive: false,
                        ),
                        const SizedBox(height: 20),
                        OrderStatusItem(
                          icon: Icons.restaurant,
                          title: 'Cooking your order',
                          isCompleted: false,
                          isActive: true,
                        ),
                        const SizedBox(height: 20),
                        OrderStatusItem(
                          icon: Icons.person,
                          title: 'Looking for courier',
                          isCompleted: false,
                          isActive: false,
                        ),
                        const SizedBox(height: 20),
                        OrderStatusItem(
                          icon: Icons.home,
                          title: 'Order delivered',
                          isCompleted: false,
                          isActive: false,
                        ),
                      ],
                    ),
                  ),
                  // Order summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              'RM23.90',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Order items
                        Consumer<Restaurant>(
                          builder: (context, restaurant, child) {
                            return Column(
                              children: restaurant.cart.map((cartItem) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      // Food image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          cartItem.food.imagePath,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 50,
                                              height: 50,
                                              color: Colors.grey.shade300,
                                              child: const Icon(Icons.fastfood),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Food details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartItem.food.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'RM${cartItem.food.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Quantity
                                      Text(
                                        '${cartItem.quantity}x',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}