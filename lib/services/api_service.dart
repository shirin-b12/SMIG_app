import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smig_app/models/ressource.dart';
import 'dart:convert';
import '../models/utilisateur.dart';

class ApiService {

  final String baseUrl = 'http://localhost:8081';

  //recup la liste des utilsateurs
  Future<List<Utilisateur>> fetchUtilisateurs() async {
    final response = await http.get(Uri.parse('

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((u) => Utilisateur.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load users from API');
    }
  }

  //recup la liste des ressources
  Future<List<Ressource>> fetchRessources() async {
    final response = await http.get(Uri.parse('$baseUrl/ressources/all'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((u) => Ressource.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load ressources from API');
    }
  }

  Future<Ressource> getRessource(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/ressources/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Ressource.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load resource from API');
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

  Future<Ressource?> createRessource(String titre, String description) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    final response = await http.post(
      Uri.parse('$baseUrl/ressources'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "idCat": 1,
        "idType": 1,
        "idTag": 1,
        "idCreateur": 2,
        "titre": titre,
        "description": description,
        "visibilite": 1,
        "dateDeCreation": formattedDate,
      }),
    );

    if (response.statusCode == 200) {
      return Ressource.fromJson(json.decode(response.body));
    } else {
      print('Failed to create resource: ${response.statusCode}');
      print('Reason: ${response.body}');
      return null;
    }
  }
  Future<bool> updateUser(int id, String nom, String prenom, String email) async {
    final response = await http.put(
      Uri.parse('$baseUrl/utilisateur/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'email': email,
      }),
    );

    return response.statusCode == 200;
  }

  Future<Utilisateur> getUtilisateur(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/utilisateur/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Utilisateur.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load user from API');
    }
  }

}
