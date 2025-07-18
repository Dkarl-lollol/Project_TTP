import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hellodekal/models/cart_item.dart';
import 'package:intl/intl.dart';

import 'food.dart';

class Restaurant extends ChangeNotifier {

  // list of food menu 36.53
  final List<Food> _menu =[

    // V1 Cafe
    Food( // nasi putih
      name: "White Rice",
      description: "Steamed white rice, the perfect base for any dish.",
      imagePath: "lib/images/v1/nasi.jpeg",
      price: 2.00, // markup 50sen
      category: FoodCategory.v1,
      availableAddons: [
        Addon(name: "Chicken Curry", price: 3.00), // murah rm1 sbb add on
        Addon(name: "Fried Chicken", price: 4.50),
        Addon(name: "Extra rice", price: 1.00),
      ],
    ),
    Food( // ayam tandoori
      name: "Tandoori Chicken",
      description: "Roasted chicken marinated in spicy Indian spices.",
      imagePath: "lib/images/v1/tandoori.jpeg",
      price: 8.50,
      category: FoodCategory.v1,
      availableAddons: [
        Addon(name: "Extra spicy", price: 0.50),
        Addon(name: "Thigh", price: 0.50),
        Addon(name: "Rice", price: 1.00),
      ],
    ),
    Food( // kari daging
      name: "Beef Curry",
      description: "Tender beef cooked in rich, aromatic curry.",
      imagePath: "lib/images/v1/daging.jpeg",
      price: 4.00,
      category: FoodCategory.v1,
      availableAddons: [
        Addon(name: "Extra beef", price: 1.00),
        Addon(name: "Rice", price: 1.00),
      ],
    ),
    Food( // kari ayam
      name: "Chicken Curry",
      description: "Chicken simmered in a flavorful Malay-style curry.",
      imagePath: "lib/images/v1/karyam.jpeg",
      price: 3.50,
      category: FoodCategory.v1,
      availableAddons: [
        Addon(name: "Thigh", price: 0.50),
        Addon(name: "Rice", price: 1.00),
      ],
    ),
    Food( // kuah kurma
      name: "Kuah Kurma",
      description: "Mild and creamy kurma gravy, usually paired with rice or meat.",
      imagePath: "lib/images/v1/kurma.jpeg",
      price: 3.50,
      category: FoodCategory.v1,
      availableAddons: [
        Addon(name: "Thigh", price: 0.50),
        Addon(name: "Rice", price: 1.00),
      ],
    ),

    // V2 Cafe
    Food( // popcorn chickeng
      name: "Popcorn Chicken",
      description: "Bite-sized crispy chicken, perfect for snacking.",
      imagePath: "lib/images/v2/popcorn.jpeg",
      price: 8.00,
      category: FoodCategory.v2,
      availableAddons: [
        Addon(name: "Cheezy", price: 1.50),
        Addon(name: "Korean", price: 2.50),
        Addon(name: "Korean Cheezy", price: 4.50),
      ],
    ),
    Food( // Tenders
      name: "Chicken Tenders",
      description: "Juicy chicken strips coated in crispy batter.",
      imagePath: "lib/images/v2/tenders.jpeg",
      price: 12.00,
      category: FoodCategory.v2,
      availableAddons: [
        Addon(name: "Garlic Sauce", price: 0.90),
        Addon(name: "Cheese", price: 0.90),
        Addon(name: "Korean", price: 0.90),
      ],
    ),
    Food( // burger
      name: "Burger",
      description: "Classic chicken or beef burger served with sauce and veggies.",
      imagePath: "lib/images/v2/burger.jpeg",
      price: 7.50,
      category: FoodCategory.v2,
      availableAddons: [
        Addon(name: "Cheese", price: 1.90),
        Addon(name: "Korean", price: 1.90),
        Addon(name: "Set", price: 6.00),
      ],
    ),
    Food( // ayam korea
      name: "Chicken Wings",
      description: "Fried chicken wings with cheese.",
      imagePath: "lib/images/v2/korea.jpeg",
      price: 11.50,
      category: FoodCategory.v2,
      availableAddons: [
        Addon(name: "Korean", price: 2.00),
        Addon(name: "Cheese + Korean", price: 5.00),
        Addon(name: "Set", price: 6.00),
      ],
    ),

    // V3 Cafe
    Food( // nasi putih
      name: "White Rice",
      description: "Steamed white rice, the perfect base for any dish.",
      imagePath: "lib/images/v1/nasi.jpeg",
      price: 2.00, // markup 50sen
      category: FoodCategory.v3,
      availableAddons: [
        Addon(name: "Extra rice", price: 1.00),
      ],
    ),
    Food( // ayam butter
      name: "Fried Butter Chicken",
      description: "Creamy, buttery fried chicken with mild spice.",
      imagePath: "lib/images/v3/butter.jpeg",
      price: 6.50,
      category: FoodCategory.v3,
      availableAddons: [
        Addon(name: "White Rice", price: 1.00),
      ],
    ),
    Food( // ayam podeh
      name: "Spicy Boneless Chicken",
      description: "Boneless fried chicken in spicy marinade.",
      imagePath: "lib/images/v3/spicy.jpeg",
      price: 5.50,
      category: FoodCategory.v3,
      availableAddons: [
        Addon(name: "White Rice", price: 1.00),
        Addon(name: "Egg", price: 1.50),
        Addon(name: "Vegetables", price: 2.00),

      ],
    ),
    Food( // ayam goreng biasa
      name: "Original Fried Chicken",
      description: "Classic seasoned fried chicken, crispy on the outside.",
      imagePath: "lib/images/v3/ayam.jpeg",
      price: 5.00,
      category: FoodCategory.v3,
      availableAddons: [
        Addon(name: "White Rice", price: 1.00),
        Addon(name: "Egg", price: 1.50),
        Addon(name: "Vegetables", price: 2.00),
      ],
    ),
    Food( // kicap
      name: "Original Fried Chicken",
      description: "Chicken coated in sweet soy sauce-based glaze.",
      imagePath: "lib/images/v3/kicap.jpeg",
      price: 4.50,
      category: FoodCategory.v3,
      availableAddons: [
        Addon(name: "White Rice", price: 1.00),
        Addon(name: "Egg", price: 1.50),
        Addon(name: "Vegetables", price: 2.00),
      ],
    ),

    // V4 Cafe
    Food( // panmee
      name: "Chilli Pan Mee",
      description: "Spicy dry noodles topped with minced meat, poached egg, and anchovies.",
      imagePath: "lib/images/v4/panmee.jpeg",
      price: 5.00,
      category: FoodCategory.v4,
      availableAddons: [
        Addon(name: "Egg", price: 1.50),
        Addon(name: "Extra Spicy", price: 0.50),
      ],
    ),
    Food( // waffle
      name: "Waffle",
      description: "Fluffy Belgian-style waffle, served sweet or savory flavours",
      imagePath: "lib/images/v4/waffle.jpeg",
      price: 3.50,
      category: FoodCategory.v4,
      availableAddons: [
        Addon(name: "Chocolate + Butter", price: 1.00),
        Addon(name: "Butter + Kaya", price: 1.00),
        Addon(name: "Kaya + Chocolate", price: 1.00),
      ],
    ),
    
    // V5 Cafe
    Food( // ng kg
      name: "Kampung Fried Rice",
      description: "Spicy Malay-style fried rice with anchovies and vegetables.",
      imagePath: "lib/images/v5/kampung.jpeg",
      price: 5.50,
      category: FoodCategory.v5,
      availableAddons: [
        Addon(name: "Egg", price: 1.00),
        Addon(name: "No Vegetables", price: 0.00),
      ],
    ),

    // V6 Cafe
    Food( // ng pataya
      name: "Pattaya Fried Rice",
      description: "Fried rice wrapped in an omelette, often served with chili sauce.",
      imagePath: "lib/images/v6/pattaya.jpeg",
      price: 5.50,
      category: FoodCategory.v6,
      availableAddons: [
        Addon(name: "Extra Rice", price: 1.00),
        Addon(name: "No Vegetables", price: 0.00),
      ],
    ),

  ];


  // user cart
  final List<CartItem> _cart = [];

  // delivery addrress
  String _deliveryAddress = 'Enter Cafe Pickup Location';

  /*

  G E T T E R S

  */

  List<Food> get menu=> _menu;
  List<CartItem> get cart => _cart;
  String get deliveryAddress => _deliveryAddress; 



  /*

  O P E R A T I O N S

  */


  // add to cart
  void addToCart(Food food, List<Addon> selectedAddons) {
  // see if there is a cart item already with the same food and selected addons
    CartItem? cartItem = _cart.firstWhereOrNull((item){
      // check if the food items are the same
      bool isSameFood = item.food == food;

      // check if the list of selected addons are the same
      bool isSameAddons = 
      ListEquality().equals(item.selectedAddons, selectedAddons);

      return isSameFood && isSameAddons;
    });

    // if item already exist, increase it's quantity
    if (cartItem != null){
      cartItem.quantity++;
    }

    // otherwise, add a new cart item to the cart
    else {
      _cart.add(
        CartItem(
          food: food, 
          selectedAddons: selectedAddons,
        ),
      );
    }
    notifyListeners();
  }

  // remove from cart
  void removeFromCart(CartItem cartItem){
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1){
      if (_cart[cartIndex].quantity > 1){
        _cart[cartIndex].quantity--;
      }else{
        _cart.removeAt(cartIndex);
      }
    }

    notifyListeners();
  }

  // get total price of cart
  double getTotalPrice(){
    double total = 0.0;

    for (CartItem cartItem in _cart){
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons){
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity;
    }
    return total;
  }

  // get total number of items in cart
  int getTotalItemCount(){
    int totalItemCount = 0;

    for(CartItem cartItem in _cart){
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
  }

  // clear cart
  void clearCart(){
    _cart.clear();
    notifyListeners();
  }

  // update delivery address
  void updateDeliveryAddress(String newAddress){
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  /*

  H E L P E R S

  */

  // Add these properties to your Restaurant class
bool _isDelivery = true;
Map<String, dynamic>? _deliveryDetails;

// Add these getters
bool get isDelivery => _isDelivery;
Map<String, dynamic>? get deliveryDetails => _deliveryDetails;

// Add these methods
void setDeliveryType(bool isDelivery) {
  _isDelivery = isDelivery;
  notifyListeners();
}

void setDeliveryDetails(Map<String, dynamic>? details) {
  _deliveryDetails = details;
  notifyListeners();
}

// Add method to get dynamic delivery fee
double getDeliveryFee() {
  if (!_isDelivery) return 0.00;
  if (_deliveryDetails?['deliveryTime'] == 'Express') return 5.00;
  return 2.50;
}

  // generate a receipt
  String displayCartReceipt(){
    final receipt = StringBuffer();
    receipt.writeln("Here is your receipt.");
    receipt.writeln();

    // format the date to include up to second only
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("----------");

    for (final cartItem in _cart){
      receipt.writeln("${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}");
      if (cartItem.selectedAddons.isNotEmpty){
        receipt.writeln("  Add-ons: ${_formatAddons(cartItem.selectedAddons)}");
      }
      receipt.writeln();
    }

    receipt.writeln("----------");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");
    receipt.writeln();
    receipt.writeln("Delivering to: $deliveryAddress");

    return receipt.toString();
  }

// format double value into money
String _formatPrice(double price) {
  return "\$${price.toStringAsFixed(2)}";
}

// format list of addons into a string summary
String _formatAddons(List<Addon> addons) {
  return addons
      .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
      .join(", ");
}
}