import 'package:flutter/material.dart';
import 'package:hellodekal/components/my_cart_tile.dart';
import 'package:hellodekal/models/restaurant.dart';
import 'package:hellodekal/pages/payment_method_page.dart';
import 'package:provider/provider.dart';
import 'package:hellodekal/pages/delivery_details_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isDelivery = true;
  Map<String, dynamic>? deliveryDetails;

// Replace your _handleCheckout method in cart_page.dart with this:

void _handleCheckout() async {
  final userCart = Provider.of<Restaurant>(context, listen: false).cart;
   
  if (userCart.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your cart is empty!')),
    );
    return;
  }

  if (isDelivery) {
    if (deliveryDetails == null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DeliveryDetailsPage(),
        ),
      );
       
      if (result != null) {
        setState(() {
          deliveryDetails = result;
        });
         
        _showTopNotification(
          context,
          deliveryDetails!['deliveryTime'] == 'Express'
            ? 'Express delivery confirmed! +RM2.50 express fee added.'
            : 'Standard delivery confirmed!',
        );
        return;
      }
    } else {
      // Calculate the EXACT same totals as shown in cart
      final restaurant = Provider.of<Restaurant>(context, listen: false);
      final orderTotal = restaurant.getTotalPrice();
      final deliveryFee = isDelivery 
          ? (deliveryDetails?['deliveryTime'] == 'Express' ? 5.00 : 2.50)
          : 0.00;
      final feesAndTaxes = 1.50;
      final discount = 2.00;
      final subtotal = orderTotal + deliveryFee + feesAndTaxes - discount;
      
      // Pass the EXACT cart calculation to payment page
      final cartTotals = {
        'orderTotal': orderTotal,
        'deliveryFee': deliveryFee,
        'feesAndTaxes': feesAndTaxes,
        'discount': discount,
        'subtotal': subtotal, // This is your final total from cart
        'isDelivery': isDelivery,
        'deliveryDetails': deliveryDetails,
      };
      
      restaurant.setDeliveryType(isDelivery);
      restaurant.setDeliveryDetails(deliveryDetails);
       
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(cartTotals: cartTotals), // Pass cart totals
        ),
      );
    }
  } else {
    // Pickup - calculate the same way
    final restaurant = Provider.of<Restaurant>(context, listen: false);
    final orderTotal = restaurant.getTotalPrice();
    final deliveryFee = 0.00; // No delivery for pickup
    final feesAndTaxes = 1.50;
    final discount = 2.00;
    final subtotal = orderTotal + deliveryFee + feesAndTaxes - discount;
    
    final cartTotals = {
      'orderTotal': orderTotal,
      'deliveryFee': deliveryFee,
      'feesAndTaxes': feesAndTaxes,
      'discount': discount,
      'subtotal': subtotal, // This is your final total from cart
      'isDelivery': isDelivery,
      'deliveryDetails': deliveryDetails,
    };
    
    restaurant.setDeliveryType(isDelivery);
    restaurant.setDeliveryDetails(deliveryDetails);
     
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(cartTotals: cartTotals), // Pass cart totals
      ),
    );
  }
}

  void _showTopNotification(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF002D72),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final userCart = restaurant.cart;
        final orderTotal = restaurant.getTotalPrice();
        
        // Use dynamic delivery fee calculation
        final deliveryFee = isDelivery 
            ? (deliveryDetails?['deliveryTime'] == 'Express' ? 5.00 : 2.50)
            : 0.00;
        final feesAndTaxes = 1.50;
        final discount = 2.00;
        final subtotal = orderTotal + deliveryFee + feesAndTaxes - discount;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Center(
              child: ToggleButtons(
                isSelected: [isDelivery, !isDelivery],
                onPressed: (index) => setState(() {
                  isDelivery = index == 0;
                  // Reset delivery details when switching to pickup
                  if (!isDelivery) {
                    deliveryDetails = null;
                  }
                }),
                borderRadius: BorderRadius.circular(24),
                fillColor: const Color(0xFF002D72),
                selectedColor: Colors.white,
                color: Colors.black,
                borderColor: const Color(0xFF002D72),
                selectedBorderColor: const Color(0xFF002D72),
                constraints: const BoxConstraints(minWidth: 100, minHeight: 36),
                children: const [Text("Delivery"), Text("Pickup")],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.black),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Clear cart?"),
                      content: const Text("Are you sure you want to remove all items from your cart?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            restaurant.clearCart();
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(color: Color(0xFF002D72)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Divider after delivery/pickup
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(vertical: 24),
                ),

                // Order header with better spacing
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Order",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Cart Items
                Expanded(
                  child: userCart.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Your cart is empty",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Add some delicious items to get started!",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            // Cart Items List
                            Expanded(
                              child: ListView.builder(
                                itemCount: userCart.length,
                                itemBuilder: (context, index) {
                                  final cartItem = userCart[index];
                                  return MyCartTile(cartItem: cartItem);
                                },
                              ),
                            ),
                            
                            // Show delivery details if confirmed (inside the scrollable area)
                            if (isDelivery && deliveryDetails != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF002D72).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF002D72).withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Delivery Details",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DeliveryDetailsPage(
                                                  existingDetails: deliveryDetails,
                                                ),
                                              ),
                                            );
                                            if (result != null) {
                                              setState(() {
                                                deliveryDetails = result;
                                              });
                                              _showTopNotification(
                                                context,
                                                'Delivery details updated!',
                                              );
                                            }
                                          },
                                          child: const Text(
                                            "Edit",
                                            style: TextStyle(
                                              color: Color(0xFF002D72),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 16, color: Color(0xFF002D72)),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${deliveryDetails!['deliveryTime']} delivery",
                                          style: TextStyle(
                                            fontWeight: deliveryDetails!['deliveryTime'] == 'Express' 
                                                ? FontWeight.w600 
                                                : FontWeight.normal,
                                            color: deliveryDetails!['deliveryTime'] == 'Express' 
                                                ? const Color(0xFF002D72) 
                                                : Colors.black87,
                                          ),
                                        ),
                                        if (deliveryDetails!['deliveryTime'] == 'Express')
                                          const Text(
                                            " (+RM2.50)",
                                            style: TextStyle(
                                              color: Color(0xFF002D72),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 16, color: Color(0xFF002D72)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text("${deliveryDetails!['location']} - ${deliveryDetails!['instructions']}"),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone, size: 16, color: Color(0xFF002D72)),
                                        const SizedBox(width: 8),
                                        Text(deliveryDetails!['phone']),
                                      ],
                                    ),
                                    if (deliveryDetails!['leaveAtDoor'] == true) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.door_front_door, size: 16, color: Color(0xFF002D72)),
                                          const SizedBox(width: 8),
                                          const Text("Leave at door"),
                                        ],
                                      ),
                                    ],
                                    if (deliveryDetails!['promoCode'] != null && 
                                        deliveryDetails!['promoCode'].toString().isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.local_offer, size: 16, color: Color(0xFF002D72)),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Promo: ${deliveryDetails!['promoCode']}",
                                            style: const TextStyle(
                                              color: Color(0xFF002D72),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                ),

                // Show pricing only if cart has items
                if (userCart.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  
                  // Pricing Breakdown
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        priceRow("Order", "RM${orderTotal.toStringAsFixed(2)}"),
                        if (isDelivery) ...[
                          if (deliveryDetails != null && deliveryDetails!['deliveryTime'] == 'Express') ...[
                            priceRow("Standard delivery", "RM2.50"),
                            priceRow("Express fee", "RM2.50", color: const Color(0xFF002D72)),
                          ] else
                            priceRow("Delivery fee", "RM${deliveryFee.toStringAsFixed(2)}"),
                        ],
                        priceRow("Fees & Taxes", "RM${feesAndTaxes.toStringAsFixed(2)}"),
                        priceRow("Student Discount", "-RM${discount.toStringAsFixed(2)}", color: Colors.orange),
                        const Divider(color: Color(0xFF002D72)),
                        priceRow("Subtotal", "RM${subtotal.toStringAsFixed(2)}", 
                                bold: true, 
                                color: const Color(0xFF002D72)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF002D72),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        isDelivery 
                            ? (deliveryDetails == null ? "Set Delivery Details" : "Go to checkout")
                            : "Go to checkout",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget priceRow(String label, String amount, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color ?? Colors.black,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: color ?? Colors.black,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}