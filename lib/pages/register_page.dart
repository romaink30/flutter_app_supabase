import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../pages/profile_page.dart';  // Make sure this import is correct

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirPasswordController = TextEditingController();

  void signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Mots de passe non identiques")));
      return;
    }

    try {
      // Call the sign-up function from AuthService
      await authService.signUpWithEmailPassword(email, password);

      // Navigate to ProfilePage on success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } catch (e) {
      // Show error message if an exception occurs
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erreur : $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("S'enregistrer")),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo-INSCRIPTION.png',
              width: 150,
              height: 150,
            ),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: "Mot de passe"),
            obscureText: true,
          ),
          TextField(
            controller: _confirPasswordController,
            decoration: const InputDecoration(labelText: "Confirmer le mot de passe"),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: signUp,
            child: const Text("S'enregistrer"),
          ),
        ],
      ),
    );
  }
}
