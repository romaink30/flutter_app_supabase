import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/home_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://eevzihiyvpigfiwsybuy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVldnppaGl5dnBpZ2Zpd3N5YnV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU1MDkwMzMsImV4cCI6MjA2MTA4NTAzM30.WeUkX7c7wOY2uhQGJ-teADCIKrJEI6lts8RMI_BgNDY',
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
 