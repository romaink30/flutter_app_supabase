import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthGate(),
    );
  }
}