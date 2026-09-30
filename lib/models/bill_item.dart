class BillItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String subtitle;
  final String deliveryTime;
  final String category;

  const BillItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.subtitle,
    required this.deliveryTime,
    required this.category,
  });
}
