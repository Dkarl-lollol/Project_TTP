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
  v1cafe,
  v2cafe,
  v3cafe,
  v4cafe,
  v5cafe,
  v6cafe,
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