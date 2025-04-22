import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage ({super.key});

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
        await authService.signInWithEmailPassword(email, password);
      }

      catch (i) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content : Text("erreur : $i")));
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
          Center(
            child: Image.asset(
              'assets/images/connexion.png',
              width: 150, 
              height: 150,
            ),
          ),

          TextField(
            controller: _emailController,
            decoration : const InputDecoration(labelText: "Email"),
          ),

          TextField(
            controller: _passwordController,
            decoration : InputDecoration(labelText: "Password"),
            obscureText: true,

          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: login, 
            child: const Text("Connexion"),
          ),
    
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const RegisterPage()
              )),
            child: const Center(child: Text("Pas de compte ? s'enregister")), 
          )
        ],
      ),
    );
  }
}