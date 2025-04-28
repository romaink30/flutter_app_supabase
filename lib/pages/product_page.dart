import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/pages/CartPage.dart';
import 'cart_item.dart';
import 'global_cart.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    print("Fetching products...");
    try {
      final data = await Supabase.instance.client
          .from('products') 
          .select();

      print('Produits récupérés : $data');

      if (mounted) {
        setState(() {
          products = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (error) {
      print('Erreur lors de la récupération des produits : $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des produits')),
      );
    }
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      GlobalCart.items.add(CartItem(
        id: product["id"],
        name: product["name"],
        price: product["price"].toDouble(),
        quantity: 1,
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🛒 Produit ajouté au panier")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 192, 137),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E4C28),
        title: const Text("Nos Produits", style: TextStyle(color: Color(0xFFF5F5DC))),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Color(0xFFF5F5DC)),
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(child: Text("Aucun produit disponible"))
          : ListView.builder(
              itemCount: products.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: const Color(0xFF3E4C28),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            if (product["image"] != null)
                              Image.network(
                                product["image"],
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 100, color: Colors.white70);
                                },
                              )
                            else
                              const Icon(Icons.image_not_supported, size: 100, color: Colors.white70),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product["name"] ?? "Nom inconnu",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF5F5DC))),
                                  const SizedBox(height: 6),
                                  Text(product["description"] ?? "Pas de description",
                                      style: const TextStyle(color: Color(0xFFEDEBD0))),
                                  const SizedBox(height: 6),
                                  Text("Prix : ${product["price"]?.toStringAsFixed(2) ?? "?"} €",
                                      style: const TextStyle(color: Color(0xFFC28840))),
                                  Text("Stock : ${product["stock"] ?? "?"}",
                                      style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: (product["stock"] ?? 0) > 0
                              ? () => addToCart(product)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC28840),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Ajouter au panier"),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
