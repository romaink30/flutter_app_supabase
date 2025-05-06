import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  String getRole(User? user) {
    final metadata = user?.appMetadata;
    return metadata != null && metadata['role'] != null
        ? metadata['role'].toString()
        : 'Utilisateur';
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'Non connecté';
    final role = getRole(user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3E4C28),
      ),
      body: Container(
        color: const Color.fromARGB(255, 184, 192, 137),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profil",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.email, color: Color(0xFFC28840)),
                const SizedBox(width: 10),
                Text(
                  "Email : $email",
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.security, color: Color(0xFFC28840)),
                const SizedBox(width: 10),
                Text(
                  "Rôle : $role",
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
