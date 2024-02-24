import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/utilisateur.dart'; // Assurez-vous que le chemin est correct

class AuthService {
  final String baseUrl = 'http://192.168.1.171:8081'; // Utilisez votre propre URL de base

  // Fonction pour vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken') != null;
  }

  // Fonction pour effectuer la connexion
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/utilisateur/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'mot_de_passe': password}),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      // Supposons que la réponse contient un token d'authentification sous 'token'
      String token = jsonDecode(response.body)['token'];
      await prefs.setString('userToken', token);
      return true;
    } else {
      return false;
    }
  }

  // Fonction pour déconnecter l'utilisateur
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
  }

  // Fonction pour créer un compte
  Future<Utilisateur?> createAccount(String nom, String prenom, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/utilisateur'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'mot_de_passe': password,
      }),
    );

    if (response.statusCode == 200) {
      // Optionnellement, connectez directement l'utilisateur après l'inscription
      return Utilisateur.fromJson(json.decode(response.body));
    }
    return null;
  }
}
