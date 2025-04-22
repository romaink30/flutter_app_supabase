import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
    final response = await _supabase.from('user').insert([{
      'email': email,
      'password': password,
      'roles': '0 0 0 0',  // Par défaut
    }]);

    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;  // Rejette l'erreur pour pouvoir la traiter ailleurs si nécessaire
    }
  }

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  String? getCurrentUserUid() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.id;  // Retourne l'UID de l'utilisateur
  }
}
