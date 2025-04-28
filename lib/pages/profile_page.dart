import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  String getRole(String email) {
    if (email == 'admin@brasserie.com') {
      return 'Admin';
    } else {
      return 'Utilisateur';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'Non connecté';

    return Container(
      color: const Color.fromARGB(255, 184, 192, 137),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Profil", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0))),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.email, color: Color(0xFFC28840)),
              const SizedBox(width: 10),
              Text("Email : $email", style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.security, color: Color(0xFFC28840)),
              const SizedBox(width: 10),
              Text("Rôle : ${getRole(email)}", style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
