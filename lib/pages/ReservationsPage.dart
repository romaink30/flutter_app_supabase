import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _reservations = [];
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    final data = await supabase
        .from('réservations')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      _reservations = List<Map<String, dynamic>>.from(data);
    });
  }

  Future<void> _addReservation() async {
    final productId = _productController.text;
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final reservationDate = _dateController.text;

    if (productId.isEmpty || reservationDate.isEmpty) {
      return;
    }

    await supabase.from('réservations').insert([
      {
        'product_id': productId,
        'quantity': quantity,
        'reservation_date': reservationDate,
        'status': 'pending',
        'user_id': 'user-id-placeholder', 
      }
    ]);

    _fetchReservations();
    _productController.clear();
    _quantityController.clear();
    _dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page de Réservations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nouvelle Réservation', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: _productController,
              decoration: const InputDecoration(labelText: 'Product ID'),
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantité'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date de Réservation'),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addReservation,
              child: const Text('Ajouter la réservation'),
            ),
            const SizedBox(height: 30),
            const Text('Réservations Existantes', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: _reservations.length,
                itemBuilder: (context, index) {
                  final reservation = _reservations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Produit: ${reservation['product_id']}'),
                      subtitle: Text(
                          'Quantité: ${reservation['quantity']} - Date: ${reservation['reservation_date']}'),
                      trailing: Text(reservation['status']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
