import 'package:flutter/material.dart';
import 'package:hellodekal/components/my_button.dart';
import 'package:hellodekal/models/food.dart';
import 'package:hellodekal/models/restaurant.dart';
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  final Food food;
  final Map<Addon, bool> selectedAddons = {};

  FoodPage({
    super.key, 
    required this.food,
  }){

    // initialize selected  addons to be false
    for (Addon addon in food.availableAddons){
      selectedAddons[addon] = false;
    }
  }

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {

  // method to add to cart
  void addToCart(Food food, Map<Addon, bool> selectedAddons) {

    // close the current food page to go back to menu
    Navigator.pop(context);

    // format the selected addons

    List<Addon> currentlySelectedAddons = [];
    for (Addon addon in widget.food.availableAddons){
      if (widget.selectedAddons[addon] == true){
        currentlySelectedAddons.add(addon);
      }
    }

    // add to cart
    context.read<Restaurant>().addToCart(food, currentlySelectedAddons);
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // scaffold UI
      Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // food image
            Image.asset(widget.food.imagePath),
        
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [          
              // food name
              Text(
                widget.food.name, 
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 20,
               ),
              ),
        
              // food price
              Text(
                '\$${widget.food.price}',
                 style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF002D72)),
               ),
        
               const SizedBox(height: 10),
            
              // food description
              Text(
                widget.food.description),
        
                const SizedBox(height: 10),
        
                const Divider(color: Color(0xFF002D72)),
        
                const SizedBox(height: 10),
        
              // addons
               const Text(
                  "Add-ons", 
                  style: TextStyle(
                  color: Color(0xFF002D72),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF002D72)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.food.availableAddons.length,
                  itemBuilder: (context, index) {
                    // get individual addon
                    Addon addon = widget.food.availableAddons[index];
                          
                    // return check box UI
                    return CheckboxListTile(
                      title: Text(addon.name),
                      subtitle: Text(
                        '\$${addon.price}',
                        style: const TextStyle(
                          color: Color(0xFF002D72),
                        ),
                      ),
                      value: widget.selectedAddons[addon],
                      onChanged: (bool? value) {
                        setState((){
                          widget.selectedAddons[addon] = value!;
                        });
                      },
                    );
                  },
                ),
              )
            ],
                  ),
          ),
        
            // button -> add to cart
            MyButton(
              onTap: () => addToCart(widget.food, widget.selectedAddons), 
              text: "Add to cart",
              backgroundColor: const Color(0xFF002D72),
              ),

              const SizedBox(height: 25),
          ],
        ),
      ),
    ),

      // back button
      SafeArea(
        child: Opacity(
          opacity: 0.6,
          child: Container(
            margin: const EdgeInsets.only(left: 25),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Color(0xFF002D72),
              ),
            onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    ],
  );
  }
}