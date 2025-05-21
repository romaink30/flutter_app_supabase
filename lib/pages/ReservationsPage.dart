import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _reservations = [];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  String formatDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
  }

  Future<void> _fetchReservations() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final reservationsData = await supabase
        .from('reservations')
        .select('quantity, status, product_id, price, created_at')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    if (reservationsData.isNotEmpty) {
      final productIds = reservationsData.map((r) => r['product_id']).toList();

      List<Map<String, dynamic>> productsData = [];

      for (var productId in productIds) {
        final productData = await supabase
            .from('products')
            .select('id, name, image')
            .eq('id', productId)
            .single();  
        if (productData != null) {
          productsData.add(productData);
        }
      }

      final Map<int, Map<String, dynamic>> productsMap = {
        for (var p in productsData) p['id']: p,
      };

      setState(() {
        _reservations = reservationsData.map((r) {
          final product = productsMap[r['product_id']];
          return {
            'quantity': r['quantity'],
            'status': r['status'],
            'product_id': r['product_id'],
            'price': r['price'],
            'created_at': r['created_at'],
            'product_name': product?['name'] ?? 'Produit inconnu',
            'product_image_url': product?['image'] ?? '',  
          };
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 192, 137),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E4C28),
        title: const Text('Mes Réservations', style: TextStyle(color: Color(0xFFF5F5DC))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _reservations.isEmpty
            ? const Center(
                child: Text('Aucune réservation trouvée.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF3E4C28))))
            : ListView.builder(
                itemCount: _reservations.length,
                itemBuilder: (context, index) {
                  final r = _reservations[index];

                  return Card(
                    color: const Color(0xFF3E4C28),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (r['product_image'] != null && r['product_image'].isNotEmpty)
                            Image.network(
                              r['product_image'] ?? '',  
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(height: 8),
                          Text('Produit : ${r['product_name']}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF5F5DC))),
                          const SizedBox(height: 8),
                          Text('Quantité : ${r['quantity']}',
                              style: const TextStyle(color: Color(0xFFEDEBD0))),
                          Text('Date : ${formatDate(r['created_at'])}',
                              style: const TextStyle(color: Color(0xFFEDEBD0))),
                          if (r['price'] != null)
                            Text('Prix : ${r['price'].toStringAsFixed(2)} €',
                                style: const TextStyle(color: Color(0xFFC28840))),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: (r['status'] == 'en attente')
                                      ? Colors.orange
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  r['status'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
