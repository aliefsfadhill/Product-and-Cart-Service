class CartItem {
  final int id;
  final String name;
  final int quantity;
  final num price; // Pakai num biar aman kalau datanya int atau double

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}