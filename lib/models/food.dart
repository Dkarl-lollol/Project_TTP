class Food {
  final String name;             // cheese burger
  final String description;      // a burger full of cheese
  final String imagePath;        // lib/images/cheeseburger
  final double price;            // 4.99 
  final FoodCategory category;   // burger
  List<Addon> availableAddons;   // [ extra cheese, sauce, extra patty]


Food({
  required this.name,
  required this.description,
  required this.imagePath,
  required this.price,
  required this.availableAddons,
  required this.category,
});

}

// food categories
enum FoodCategory{
  v1,
  v2,
  v3,
  v4,
  v5,
  v6,
}

// food addons
class Addon {
  String name;
  double price;

  Addon({
    required this.name,
    required this.price,
  });

}