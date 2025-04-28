class CartItem {
  final int id;
  final String name;
  final double price;
  int quantity;

  CartItem({required this.id, required this.name, required this.price, required this.quantity});

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: this.id,
      name: this.name,
      price: this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
