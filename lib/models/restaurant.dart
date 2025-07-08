import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hellodekal/models/cart_item.dart';
import 'package:intl/intl.dart';

import 'food.dart';

class Restaurant extends ChangeNotifier {

  // list of food menu
  final List<Food> _menu =[
    // burgers
    Food(
      name: "Cheeseburger",
      description: " A juicy beef patty with melted cheddar, lettuce, tomato, and a hint of onion and pickle.",
      imagePath: "lib/images/burgers",
      price: 0.99,
      category: FoodCategory.v1cafe,
      availableAddons: [
        Addon(name: "Extra cheese", price: 0.99),
        Addon(name: "Bacon", price: 1.29),
        Addon(name: "Avocado", price: 2.99),
      ],
    ),
    
    Food(
      name: "BBQ rebuih",
      description: " Barbeque sauce.",
      imagePath: "lib/images/burgers",
      price: 2.99,
      category: FoodCategory.v2cafe,
      availableAddons: [
        Addon(name: "Extra cheese", price: 0.99),
        Addon(name: "Bacon", price: 1.29),
        Addon(name: "Avocado", price: 2.99),
      ],
    ),

    // salads
    Food(
      name: "Caesar salad",
      description: " Crispy.",
      imagePath: "lib/images/salads",
      price: 7.99,
      category: FoodCategory.v3cafe,
      availableAddons: [
        Addon(name: "Extra cheese", price: 0.99),
        Addon(name: "Bacon", price: 1.29),
        Addon(name: "Avocado", price: 2.99),
      ],
    ),


    // sides

    // desserts

    // drinks

  ];


  // user cart
  final List<CartItem> _cart = [];

  // delivery addrress
  String deliveryAddress = 'Cafe apa';
  /*

  G E T T E R S

  */

  List<Food> get menu=> _menu;
  List<CartItem> get cart => _cart;

 


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
    deliveryAddress = newAddress;
    notifyListeners();
  }

  /*

  H E L P E R S

  */

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
    return "\$ +{price.toStringAsFixed(2)}";
  }

  // format list of addons into a string summary
  String _formatAddons(List<Addon> addons) {
    return addons.map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
    .join(",");
  }
}