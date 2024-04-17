import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smig_app/models/categorie.dart';
import 'package:smig_app/models/ressource.dart';
import 'package:smig_app/models/type.dart';
import 'package:smig_app/services/auth_service.dart';
import 'dart:convert';
import '../models/commentaire.dart';
import '../models/tag.dart';
import '../models/tiny_ressource.dart';
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
  Future<List<int>> fetchFavorie(int? id) async {
    final response = await http.get(Uri.parse('$baseUrl/favori/$id'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<int> ids = jsonResponse.map((u) => u['id_ressource'] as int).toList();
      return ids;
    } else {
      throw Exception('Failed to load favorite resource IDs from API');
    }
  }

  // Fetch a single resource by its ID
  Future<TinyRessource> fetchTinyRessource(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/ressources/$id'));
    print(response.body);
    if (response.statusCode == 200) {
      return TinyRessource.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load resource from API');
    }
  }

  Future<List<Categorie>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories/all'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((u) => Categorie.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load categories from API');
    }
  }

  Future<List<Type>> fetchTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/types/all'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((u) => Type.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load categories from API');
    }
  }

  Future<List<Tag>> fetchTags() async {
    final response = await http.get(Uri.parse('$baseUrl/tags/all'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((u) => Tag.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load categories from API');
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

  //creation compte
  Future<Utilisateur?> createAccount(
      String nom, String prenom, String email, String password) async {
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

  Future<Ressource?> createRessource(String titre, String description,
      int idCat, int idType, int idTag) async {
    print('first');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    int idCreateur = await AuthService().getCurrentUser();
    final response = await http.post(
      Uri.parse('$baseUrl/ressources'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "idCat": idCat,
        "idType": idType,
        "idTag": idTag,
        "idCreateur": idCreateur,
        "titre": titre,
        "description": description,
        "visibilite": 1,
        "dateDeCreation": formattedDate,
      }),
    );
    print('here');

    if (response.statusCode == 200) {
      return Ressource.fromJson(json.decode(response.body));
      print('ok');
    } else {
      print('Failed to create resource: ${response.statusCode}');
      print('Reason: ${response.body}');
      return null;
    }
  }

  Future<bool> updateRessource(
      int ressourceId, String titre, String description,
      int idCat, int idType, int idTag) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    int idCreateur = await AuthService().getCurrentUser();
    final response = await http.put(
      Uri.parse('$baseUrl/ressources/update/$ressourceId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "idCat": idCat,
        "idType": idType,
        "idTag": idTag,
        "idCreateur": idCreateur,
        "titre": titre,
        "description": description,
        "dateDeCreation": formattedDate,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update resource: ${response.statusCode}');
      print('Reason: ${response.body.toString()}');
      return false;
    }
  }

  deleteRessource(int ressourceId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/ressources/delete/$ressourceId'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Failed to delete resource: ${response.statusCode}');
      print('Reason: ${response.body}');
      return null;
    }
  }

  deleteUtilisateur(int userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/utilisateurs/delete/$userId'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Failed to delete utilisateur: ${response.statusCode}');
      print('Reason: ${response.body}');
      return null;
    }
  }

  Future<bool> updateUser(
      int id, String nom, String prenom, String email) async {
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
      //print(jsonResponse);
      return Utilisateur.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load user from API');
    }
  }

  Future<List<Commentaire>> fetchComments(int ressourceId) async {
    final response =
    await http.get(Uri.parse('$baseUrl/commentaire/$ressourceId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((c) => Commentaire.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load comments from API');
    }
  }

  Future<Commentaire?> createComment(
      String texteCommentaire, int idUtilisateur, int idRessource) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    print(texteCommentaire);
    print(idRessource);
    print(idUtilisateur);
    final response = await http.post(
      Uri.parse('$baseUrl/commentaire'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'commentaire': texteCommentaire,
        'id_utilisateur_redacteur': idUtilisateur,
        'id_ressource': idRessource,
        'date_de_creation': formattedDate
      }),
    );

    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          return Commentaire.fromJson(data);
        } else {
          throw Exception('Le corps de la réponse est null.');
        }
      } else {
        throw Exception(
            'Failed to post comment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la conversion de la réponse en Commentaire: $e');
      return null;
    }
  }

  Future<Categorie?> createCat(String nom) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nom_cat': nom,
      }),
    );

    if (response.statusCode == 200) {
      return Categorie.fromJson(json.decode(response.body));
    } else {
      print('Error status code: ${response.statusCode}');
      print('Error body: ${response.body}');
      return null;
    }
  }

  Future<Tag?> createTag(String nom) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tags'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nom_tag': nom,
      }),
    );

    if (response.statusCode == 200) {
      return Tag.fromJson(json.decode(response.body));
    } else {
      print('Error status code: ${response.statusCode}');
      print('Error body: ${response.body}');
      return null;
    }
  }

  Future<Type?> createType(String nom) async {
    final response = await http.post(
      Uri.parse('$baseUrl/types'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nom_type': nom,
      }),
    );

    if (response.statusCode == 200) {
      return Type.fromJson(json.decode(response.body));
    } else {
      print('Error status code: ${response.statusCode}');
      print('Error body: ${response.body}');
      return null;
    }
  }

  Future<List<TinyRessource>> fetchRessourcesByCreateur(int createurId) async {
    final response = await http.get(Uri.parse('$baseUrl/ressources/byCreateur/$createurId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TinyRessource.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load resources for creator ID $createurId from API');
    }
  }


}
