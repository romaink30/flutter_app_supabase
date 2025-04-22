import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/home_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pmviqfvvzquiullnmbts.supabase.co/',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBtdmlxZnZ2enF1aXVsbG5tYnRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUzMzI5NjQsImV4cCI6MjA2MDkwODk2NH0.Zek4mLvMqmgtZEtW0y7uuumRwuixo4ZMPGO_7m8qNXQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Appli avec Supabase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
