import 'package:flutter/material.dart';
import 'package:hellodekal/models/restaurant.dart';
import 'package:provider/provider.dart';

final textController = TextEditingController();

class MyCurrentLocation extends StatelessWidget {
  const MyCurrentLocation
  ({super.key});

  void openLocationSearch(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text ("Your location"),
        content: const TextField(
          decoration:  InputDecoration(hintText: "Enter Cafe.."),
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text ('Cancel'),
          ),

          // save button
           MaterialButton(
            onPressed: () {
              // update delivery address
              String newAddress = textController.text;
              context.read<Restaurant>().updateDeliveryAddress(newAddress);      
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text ('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deliver Now",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          GestureDetector(
            onTap: () => openLocationSearch(context),
            child: Row(
              children: [
                  Consumer<Restaurant>(
            builder: (context, restaurant, child) => Text(
                restaurant.deliveryAddress,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}