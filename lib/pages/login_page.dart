import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/pages/register_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 192, 137),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E4C28),
        title: const Text(
          "Connexion",
          style: TextStyle(color: Color(0xFFF5F5DC)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF5F5DC)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        children: [
          Center(
            child: Image.asset(
              'assets/images/brasserie_logo.png',
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _emailController,
            style: const TextStyle(color: Color(0xFFF5F5DC)),
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: const TextStyle(color: Color(0xFFF5F5DC)),
              filled: true,
              fillColor: Color(0xFF3E4C28),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(color: Color(0xFFF5F5DC)),
            decoration: InputDecoration(
              labelText: "Mot de passe",
              labelStyle: const TextStyle(color: Color(0xFFF5F5DC)),
              filled: true,
              fillColor: Color(0xFF3E4C28),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: login,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC28840),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              "Connexion",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            child: const Center(
              child: Text(
                "Pas de compte ? S'enregistrer",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
