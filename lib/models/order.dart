class Order {
  final String id;
  final List<String> items;
  final double total;
  final String status;
  final DateTime date;
  final String restaurant;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.date,
    required this.restaurant,
  });
}