import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smig_app/models/ressource.dart';
import '../models/utilisateur.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8081';

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
      return true;
    } else {
      return false;
    }
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
  }

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
      return Utilisateur.fromJson(json.decode(response.body));
    }
    return null;
  }

  Future<Ressource?> createRessource(String titre, String description, DateTime date_de_creation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ressources'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        "idCat": 1,
        "idType": 1,
        "idTag": 1,
        "idCreateur": 2,
        "titre": titre,
        "description": description,
        "visibilite": 1,
        "dateDeCreation": date_de_creation.toString(),
      }),
    );

    if (response.statusCode == 200) {
      return Ressource.fromJson(json.decode(response.body));
    }
    else{
      print(response.statusCode);
      print(response.reasonPhrase);
    }
    return null;
  }
}
