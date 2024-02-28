import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/utilisateur.dart';

class AuthService {
  static String baseUrl = 'http://localhost:8081';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken') != null;
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/utilisateur/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'mot_de_passe': password}),
    );

    if (response.statusCode == 200) {
      final String token = response.body;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userToken', token);
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
  }

  Future<bool> createAccount(String nom, String prenom, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/utilisateur'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'mot_de_passe': password
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}
