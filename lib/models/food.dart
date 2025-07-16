// lib/models/food.dart - UPDATED with FoodCategory enum

// Food category enum
enum FoodCategory {
  v1,
  v2, 
  v3,
  v4,
  v5,
  v6,
}

// Extension to get display name for categories
extension FoodCategoryExtension on FoodCategory {
  String get displayName {
    switch (this) {
      case FoodCategory.v1:
        return 'V1 Cafe';
      case FoodCategory.v2:
        return 'V2 Cafe';
      case FoodCategory.v3:
        return 'V3 Cafe';
      case FoodCategory.v4:
        return 'V4 Cafe';
      case FoodCategory.v5:
        return 'V5 Cafe';
      case FoodCategory.v6:
        return 'V6 Cafe';
    }
  }
}

// Food item
class Food {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory category;
  final List<Addon> availableAddons;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.availableAddons,
  });
}

// Food addons
class Addon {
  final String name;
  final double price;

  Addon({
    required this.name,
    required this.price,
  });
}