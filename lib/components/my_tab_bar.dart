import 'package:flutter/material.dart';
import 'package:hellodekal/models/food.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;

  const MyTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      indicatorColor: Color(0xFF002B6C), // blue underline
      labelColor: Color(0xFF002B6C),     // selected label color
      unselectedLabelColor: Colors.black, // unselected label color
      tabs: FoodCategory.values.map((category) {
        return Tab(text: category.name); // or customize text
      }).toList(),
    );
  }
}
