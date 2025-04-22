import 'package:flutter/material.dart';

import '../auth/auth_service.dart';

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

    void signUp () async {
      final email = _emailController.text;
      final password = _passwordController.text;
      final confirmPassword = _confirPasswordController.text;

      if(password != confirmPassword){
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("mauvais mot de passe")));
        return;
      }

      try {
        await authService.signUpWithEmailPassword(email, password);
        Navigator.pop(context);
      } 

      catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erreur : $e")));
        }
      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title: const Text("s'enregistrer")
        ),
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
            decoration : const InputDecoration(labelText: "Email"),
          ),

          TextField(
            controller: _passwordController,
            decoration : InputDecoration(labelText: "Password"),
            obscureText: true,
          ),

          TextField(
            controller: _confirPasswordController,
            decoration : InputDecoration(labelText: " Confirm Password"),
            obscureText: true,
          ),

          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: signUp, 
            child: const Text("s'enregistrer"),
          ),

        ],
      ),
    );
  }
}