import 'package:news_api/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Login
  Future<AuthResponse> login(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign Up
  Future<AuthResponse> register(String email, String password) async {
    return await supabase.auth.signUp(password: password, email: email);
  }

  Future<void> signOut() async {
    return await supabase.auth.signOut();
  }

  String? userEmail() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
