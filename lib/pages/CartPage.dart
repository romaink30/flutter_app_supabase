import 'package:flutter/material.dart';
import 'cart_item.dart';
import 'global_cart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<void> _checkout() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception("Utilisateur non authentifié");
      }

      final reservations = GlobalCart.items.map((item) {
        return {
          'user_id': user.id,
          'product_id': item.id, 
          'quantity': item.quantity,
          'reservation_date': DateTime.now().toIso8601String(),
          'status': 'en attente',
        };
      }).toList();

      final response = await Supabase.instance.client.from('reservations').insert(reservations).select();
      setState(() {
        GlobalCart.items.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Réservation réussie !'),
      ));

    } catch (e) {
      print("Erreur lors du checkout: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur est survenue: ${e.toString()}'),
      ));
    }
  }
  double calculateTotal() {
    double total = 0.0;
    for (var item in GlobalCart.items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 192, 137),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E4C28),
        title: const Text("Mon Panier", style: TextStyle(color: Color(0xFFF5F5DC))),
        iconTheme: const IconThemeData(color: Color(0xFFF5F5DC)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GlobalCart.items.isEmpty
            ? Center(child: Text("Votre panier est vide", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: GlobalCart.items.length,
                      itemBuilder: (context, index) {
                        var item = GlobalCart.items[index];
                        return CartItemWidget(
                          item: item,
                          onQuantityChanged: (quantity) {
                            setState(() {
                              item.quantity = quantity;
                            });
                          },
                          onRemove: () {
                            setState(() {
                              GlobalCart.items.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Total: \$${calculateTotal().toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF5F5DC)),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _checkout, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC28840),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      "Passer à la caisse",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  CartItemWidget({required this.item, required this.onQuantityChanged, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: const Color(0xFF3E4C28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFF5F5DC))),
                Text("Prix: \$${item.price}", style: TextStyle(fontSize: 14, color: Color(0xFFF5F5DC))),
                Text("Total: \$${(item.price * item.quantity).toStringAsFixed(2)}", style: TextStyle(fontSize: 14, color: Color(0xFFC28840))),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Color(0xFFF5F5DC)),
                      onPressed: item.quantity > 1
                          ? () => onQuantityChanged(item.quantity - 1)
                          : null,
                    ),
                    Text(item.quantity.toString(), style: TextStyle(color: Color(0xFFF5F5DC))),
                    IconButton(
                      icon: Icon(Icons.add, color: Color(0xFFF5F5DC)),
                      onPressed: () => onQuantityChanged(item.quantity + 1),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
