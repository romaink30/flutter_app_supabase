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

  final Map<String, String> productNames = {
    '1': 'Blonde',
    '2': 'Brune',
    '3': 'IPA',
    '4': 'Whiskey',
    '5': 'GIN',
  };

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final data = await supabase
        .from('reservations')
        .select('quantity, reservation_date, status, product_id, price')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    setState(() {
      _reservations = List<Map<String, dynamic>>.from(data);
    });
  }

  String formatDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime); 
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
                    style: TextStyle(fontSize: 16, color: Color(0xFF3E4C28))),
              )
            : ListView.builder(
                itemCount: _reservations.length,
                itemBuilder: (context, index) {
                  final r = _reservations[index];

                  final productName = productNames[r['product_id'].toString()] ?? 'Produit non trouvé';

                  return Card(
                    color: const Color(0xFF3E4C28),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Produit : $productName',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF5F5DC))),
                          const SizedBox(height: 8),
                          Text('Quantité : ${r['quantity']}',
                              style: const TextStyle(color: Color(0xFFEDEBD0))),
                          Text('Date : ${formatDate(r['reservation_date'])}',
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
                          )
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
