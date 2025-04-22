import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/pages/register_page.dart';
import 'package:flutter_application_1/pages/profile_page.dart'; // Import de la page profile

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // Tentative de connexion
      await authService.signInWithEmailPassword(email, password);

      // Si la connexion réussie, on redirige vers la page profile
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } catch (e) {
      // Gestion des erreurs de connexion
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
      appBar: AppBar(
        title: const Text("Connexion"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        children: [
          // Logo
          Center(
            child: Image.asset(
              'assets/images/connexion.png',
              width: 150,
              height: 150,
            ),
          ),

          // Email Input
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),

          // Password Input
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
          ),

          const SizedBox(height: 12),

          // Connexion Button
          ElevatedButton(
            onPressed: login,
            child: const Text("Connexion"),
          ),

          const SizedBox(height: 12),

          // Lien vers la page d'inscription
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            ),
            child: const Center(child: Text("Pas de compte ? S'enregistrer")),
          ),
        ],
      ),
    );
  }
}
