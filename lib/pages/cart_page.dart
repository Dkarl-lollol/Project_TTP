import 'package:flutter/material.dart';
import 'package:hellodekal/components/my_button.dart';
import 'package:hellodekal/components/my_cart_tile.dart';
import 'package:hellodekal/models/restaurant.dart';
import 'package:hellodekal/pages/payment_page.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isDelivery = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final userCart = restaurant.cart;
        final orderTotal = restaurant.getTotalPrice();
        
        // Calculate totals
        final deliveryFee = isDelivery ? 2.50 : 0.00;
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
              onPressed: (index) => setState(() => isDelivery = index == 0),
              borderRadius: BorderRadius.circular(24),
              fillColor: const Color(0xFF002D72), // ✅ Updated to your blue
              selectedColor: Colors.white,
              color: Colors.black,
              borderColor: const Color(0xFF002D72), // ✅ Updated border color
              selectedBorderColor: const Color(0xFF002D72), // ✅ Updated selected border
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
                            style: TextStyle(color: Color(0xFF002D72)), // ✅ Blue color
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
          margin: const EdgeInsets.symmetric(vertical: 24), // More space around divider
        ),

        // Order header with better spacing
        const Text(
          "Order",
          style: TextStyle(
            fontSize: 26, // Slightly smaller
            fontWeight: FontWeight.w600, // Less bold
            color: Colors.black87, // Softer black
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
                      : ListView.builder(
                          itemCount: userCart.length,
                          itemBuilder: (context, index) {
                            final cartItem = userCart[index];
                            return MyCartTile(cartItem: cartItem);
                          },
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
                        if (isDelivery)
                          priceRow("Delivery fee", "RM${deliveryFee.toStringAsFixed(2)}"),
                        priceRow("Fees & Taxes", "RM${feesAndTaxes.toStringAsFixed(2)}"),
                        priceRow("Student Discount", "-RM${discount.toStringAsFixed(2)}", color: Colors.orange),
                        const Divider(color: Color(0xFF002D72)), // ✅ Blue divider
                        priceRow("Subtotal", "RM${subtotal.toStringAsFixed(2)}", 
                                bold: true, 
                                color: const Color(0xFF002D72)), // ✅ Blue subtotal
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Checkout Button
                  MyButton(
                    text: "Go to checkout",
                    backgroundColor: const Color(0xFF002D72), // ✅ Blue button
                    onTap: () {
                      if (userCart.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Your cart is empty!')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentPage()),
                      );
                    },
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