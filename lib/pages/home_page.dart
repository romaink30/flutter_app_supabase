import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'register_page.dart';
import '../auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        actions: user == null
            ? [
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginPage()));
                  },
                  child: const Text("Connexion", style: TextStyle(color: Color.fromARGB(255, 0, 106, 255))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()));
                  },
                  child: const Text("Inscription", style: TextStyle(color: Color.fromARGB(255, 0, 106, 255))),
                ),
              ]
            : [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      user.email ?? '',
                      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await authService.logout();
                    if (mounted) {
                      setState(() {});
                    }
                  },
                )
              ],
      ),
      body: Center(
        child: user == null
            ? const Text(
                "Bienvenue sur notre application de systeme d\'uploads !",
                style: TextStyle(fontSize: 20),
              )
            : const ProfilePage(), 
      ),
    );
  }
}
