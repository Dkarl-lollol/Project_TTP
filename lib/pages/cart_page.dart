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

// Inside Consumer<Restaurant> builder
final orderTotal = restaurant.getTotalPrice;
//final deliveryFee = restaurant.deliveryFee;
//final tax = restaurant.tax;
//final discount = restaurant.discount;
//final subtotal = restaurant.subtotal;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: ToggleButtons(
              isSelected: [isDelivery, !isDelivery],
              onPressed: (index) => setState(() => isDelivery = index == 0),
              borderRadius: BorderRadius.circular(24),
              fillColor: const Color(0xFF002B6C),
              selectedColor: Colors.white,
              color: Colors.black,
              constraints: const BoxConstraints(minWidth: 100, minHeight: 36),
              children: const [Text("Delivery"), Text("Pickup")],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.black),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Clear cart?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              restaurant.clearCart();
                            },
                            child: const Text("Yes")),
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
                // Cart Items
                Expanded(
                  child: userCart.isEmpty
                      ? const Center(child: Text("Cart is empty..."))
                      : ListView.builder(
                          itemCount: userCart.length,
                          itemBuilder: (context, index) {
                            final cartItem = userCart[index];
                            return MyCartTile(cartItem: cartItem);
                          },
                        ),
                ),
                const SizedBox(height: 20),

                // Pricing Breakdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    priceRow("Order", "RM${orderTotal().toStringAsFixed(2)}"),
                    priceRow("Delivery fee", "RM${5.00.toStringAsFixed(2)}"), // hardcoded
                    priceRow("Fees & Taxes", "RM${1.50.toStringAsFixed(2)}"), // hardcoded
                    priceRow("Discount", "-RM${2.00.toStringAsFixed(2)}", color: Colors.orange), // hardcoded
                    const Divider(),
                    priceRow("Subtotal", "RM${2.00.toStringAsFixed(2)}", bold: true), // computed subtotal
                    const SizedBox(height: 20),
                   /*
                    priceRow("Delivery fee", "RM${deliveryFee.toStringAsFixed(2)}"),
                    priceRow("Fees & Taxes", "RM${tax.toStringAsFixed(2)}"),
                    priceRow("Discount", "-RM${discount.toStringAsFixed(2)}", color: Colors.orange),
                    const Divider(),
                    priceRow("Subtotal", "RM${subtotal.toStringAsFixed(2)}", bold: true),
                    const SizedBox(height: 20),
                    */
                  ],
                ),

                // Checkout Button
                MyButton(
                  text: "Go to checkout",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentPage()),
                  ),
                ),
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
          Text(label,
              style: TextStyle(
                  color: color ?? Colors.black,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(amount,
              style: TextStyle(
                  color: color ?? Colors.black,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
