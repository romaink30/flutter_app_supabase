import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/CartPage.dart';
import 'package:flutter_application_1/pages/ReservationsPage.dart';
import 'package:flutter_application_1/pages/product_page.dart';
import 'package:flutter_application_1/pages/profile_page.dart';
import 'package:flutter_application_1/pages/ReservationsPage.dart';
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
  int selectedIndex = 0;

  final List<Widget> pages = [
    Center(
      child: Text(
        'Bienvenue dans notre brasserie artisanale 🍺',
        style: TextStyle(fontSize: 20, color: Color(0xFF3E4C28)),
      ),
    ),
    ProductPage(),
    CartPage(),
    ReservationsPage(), 
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 192, 137),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E4C28),
        title: Row(
          children: [
            Image.asset(
              'assets/images/brasserie_logo.png',
              height: 50,
            ),
            const SizedBox(width: 8),
            const Text(
              "Accueil",
              style: TextStyle(color: Color(0xFFF5F5DC)),
            ),
          ],
        ),
        actions: user == null
            ? [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    "Connexion",
                    style: TextStyle(color: Color(0xFFF5F5DC)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Inscription",
                    style: TextStyle(color: Color(0xFFF5F5DC)),
                  ),
                ),
              ]
            : [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      user.email ?? '',
                      style: const TextStyle(color: Color(0xFFF5F5DC)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Color(0xFFF5F5DC)),
                  onPressed: () async {
                    await authService.logout();
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
              ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF3E4C28),
          primaryColor: const Color(0xFFC28840),
          textTheme: Theme.of(context).textTheme.copyWith(
                bodySmall: const TextStyle(color: Color(0xFFF5F5DC)),
              ),
        ),
        child: BottomNavigationBar(
          selectedItemColor: const Color(0xFFC28840),
          unselectedItemColor: const Color(0xFFF5F5DC),
          currentIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
            BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Produits'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panier'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Réservations'), 
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
