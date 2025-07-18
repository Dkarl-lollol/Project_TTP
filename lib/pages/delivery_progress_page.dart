import 'package:flutter/material.dart';
import 'package:hellodekal/models/restaurant.dart';
import 'package:hellodekal/services/database/firestore.dart';
import 'package:provider/provider.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});
  
  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  // get access to db
  FirestoreService db = FirestoreService();

  @override
  void initState() {
    super.initState();
    // if we get to this page, submit order to firestore db
    String receipt = context.read<Restaurant>().displayCartReceipt();
    db.saveOrderToDatabase(receipt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Cooking in Progress..",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Thank you message
            const Text(
              'Thank you for your order!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Receipt Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF002D72), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Here is your receipt.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF002D72),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Date and time
                  Text(
                    DateTime.now().toString().substring(0, 19),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Divider
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  
                  // Order items
                  Consumer<Restaurant>(
                    builder: (context, restaurant, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cart items
                          ...restaurant.cart.map((cartItem) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${cartItem.quantity} x ${cartItem.food.name}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'RM${(cartItem.food.price * cartItem.quantity).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          
                          const SizedBox(height: 16),
                          
                          // Divider
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          
                          // Order summary calculations
                          _buildSummaryRow('Order Total', restaurant.getTotalPrice()),
                          _buildSummaryRow('Delivery Fee', 2.50),
                          _buildSummaryRow('Fees & Taxes', 1.50),
                          _buildSummaryRow('Discount', -2.00, isNegative: true),
                          
                          const SizedBox(height: 8),
                          Container(
                            height: 1,
                            color: const Color(0xFF002D72),
                          ),
                          const SizedBox(height: 8),
                          
                          // Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Items:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '${restaurant.cart.length}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Price:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF002D72),
                                ),
                              ),
                              Text(
                                'RM${(restaurant.getTotalPrice() + 2.50 + 1.50 - 2.00).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF002D72),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20), // Extra spacing after total price
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Estimated delivery time
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF002D72).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color(0xFF002D72),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Estimated delivery time is: ${_getEstimatedDeliveryTime()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF002D72),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Return to Home Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to home page and clear all previous routes
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/home', 
                    (route) => false,
                  );
                  // Alternative: Direct navigation (uncomment if you prefer this)
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const HomePage()),
                  //   (route) => false,
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002D72),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Return to Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 120), // Extra spacing to prevent overlap with bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Text(
            isNegative 
              ? '-RM${amount.abs().toStringAsFixed(2)}'
              : 'RM${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              color: isNegative ? Colors.orange : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _getEstimatedDeliveryTime() {
    final now = DateTime.now();
    final deliveryTime = now.add(const Duration(minutes: 30));
    return '${deliveryTime.hour.toString().padLeft(2, '0')}:${deliveryTime.minute.toString().padLeft(2, '0')}';
  }

  // Custom bottom nav bar - message // call org yg bungkus
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 120, // Increased height for better visibility
      decoration: const BoxDecoration(
        color: Color(0xFF002D72),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          // profile pic org yg bungkus
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(18), // Increased padding
            child: const Icon(
              Icons.person,
              color: Color(0xFF002D72),
              size: 28, // Increased icon size
            ),
          ),
          const SizedBox(width: 15),
          
          // details org yg bungkus
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Abdullah",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Increased font size
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Food handler",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // Increased font size
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // message and call buttons
          Row(
            children: [
              // message button
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(15), // Increased padding
                child: const Icon(
                  Icons.message,
                  color: Color(0xFF002D72),
                  size: 24, // Increased icon size
                ),
              ),
              const SizedBox(width: 12),
              
              // call button
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(15), // Increased padding
                child: const Icon(
                  Icons.call,
                  color: Colors.green,
                  size: 24, // Increased icon size
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}