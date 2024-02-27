import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/utilisateur.dart';

class ApiService {

  final String baseUrl = 'http://localhost:8081';

  //recup la liste des utilsateurs
  Future<List<Utilisateur>> fetchUtilisateurs() async {
    final response = await http.get(Uri.parse('$baseUrl/utilisateur'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((u) => Utilisateur.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load users from API');
    }
  }

  Future<String?> signup(Utilisateur utilisateur) async {
    final response = await http.post(
      Uri.parse('$baseUrl/utilisateur'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(utilisateur),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Échec de la création de compte');
    }
  }

  //fonction de connexion
  /*Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/utilisateur/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'mot_de_passe': password}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }*/

  //creation compte
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

}
