import 'package:flutter/material.dart';
import 'package:hellodekal/components/my_quantity_selector.dart';
import 'package:hellodekal/models/cart_item.dart';
import 'package:hellodekal/models/restaurant.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback? onRemove;

  const MyCartTile({
    super.key, 
    required this.cartItem,
    this.onRemove,
    });

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) => Container(
        decoration: BoxDecoration(
          color: Colors.white, // ✅ White background like Figma
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 12), // ✅ Reduced margin for better spacing
        child: Padding(
          padding: const EdgeInsets.all(16), // ✅ Better internal padding
          child: Row(
            children: [
              // food image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  cartItem.food.imagePath,
                  height: 60, // ✅ Smaller image like Figma
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),

              // name and price section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // food name
                    Text(
                      cartItem.food.name,
                      style: const TextStyle(
                        color: Colors.black, // ✅ Black text on white background
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // food price
                    Text(
                      'RM${cartItem.food.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.grey.shade600, // ✅ Grey price text
                        fontSize: 14,
                      ),
                    ),
                    
                    // addons section (if any)
                    if (cartItem.selectedAddons.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: cartItem.selectedAddons
                            .map(
                              (addon) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF002D72).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFF002D72).withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  '${addon.name} (+RM${addon.price.toStringAsFixed(2)})',
                                  style: const TextStyle(
                                    color: Color(0xFF002D72),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // quantity selector
              Column(
                children: [
                  // Quantity selector
                  QuantitySelector(
                    quantity: cartItem.quantity,
                    food: cartItem.food,
                      onDecrement: () {
                         if (cartItem.quantity == 1) {
                        // Show confirmation dialog before removing THIS SPECIFIC item
                        showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Remove item?"),
                      content: Text("Remove ${cartItem.food.name} from your cart?"),
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
                            // Remove only this specific cart item, not the entire cart
                            restaurant.removeFromCart(cartItem);
                            
                            // Show confirmation snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${cartItem.food.name} removed from cart"),
                                backgroundColor: Colors.orange,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: const Text(
                            "Remove",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                        // Just decrement the quantity by 1
                      restaurant.removeFromCart(cartItem);
                }
                      },
                    onIncrement: () {
                      restaurant.addToCart(
                        cartItem.food, 
                        cartItem.selectedAddons
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}