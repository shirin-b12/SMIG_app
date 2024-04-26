import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smig_app/models/categorie.dart';
import 'package:smig_app/models/ressource.dart';
import 'package:smig_app/models/type.dart';
import 'package:smig_app/models/types_relation.dart';
import 'package:smig_app/services/auth_service.dart';
import 'dart:convert';
import '../models/commentaire.dart';
import '../models/relation.dart';
import '../models/tag.dart';
import '../models/tiny_ressource.dart';
import '../models/utilisateur.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.get(Uri.parse('$baseUrl/favori/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      });
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<int> ids =
          jsonResponse.map((u) => u['id_ressource'] as int).toList();
      return ids;
    } else {
      throw Exception('Failed to load favorite resource IDs from API');
    }
  }

  // Fetch a single resource by its ID
  Future<TinyRessource> fetchTinyRessource(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/ressources/$id'));
    if (response.statusCode == 200) {
      return TinyRessource.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load resource from API');
    }
  }

  Future<List<Categorie>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((u) => Categorie.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load categories from API');
    }
  }

  Future<List<Type>> fetchTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/types'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((u) => Type.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load categories from API');
    }
  }

  Future<List<Tag>> fetchTags() async {

    final response = await http.get(Uri.parse('$baseUrl/tags'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((u) => Tag.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load categories from API');
    }
  }

  Future<Ressource> getRessource(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.get(Uri.parse('$baseUrl/ressources/$id'),
      headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
    },);

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

  Future<Ressource?> createRessource(String titre, String description, int idCat, int idType, int idTag) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    int idCreateur = await AuthService().getCurrentUser();
    final response = await http.post(
      Uri.parse('$baseUrl/ressources'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
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

    if (response.statusCode == 200) {
      return Ressource.fromJson(json.decode(response.body));
    } else {
      print('Failed to create resource: ${response.statusCode}');
      print('Reason: ${response.body}');
      return null;
    }
  }

  Future<bool> updateRessource(int ressourceId, String titre, String description) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    final response = await http.put(
      Uri.parse('$baseUrl/ressources/$ressourceId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "idCat": 1,
        "idType": 1,
        "idTag": 1,
        "idCreateur": 5,
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

  Future<bool> updateValidationRessource(int ressourceId, bool resultat) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.put(
      Uri.parse('$baseUrl/ressources/$ressourceId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'validate_Ressource': resultat}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update resource validation: ${response.statusCode}');
      print('Reason: ${response.body.toString()}');
      return false;
    }
  }

  deleteRessource(int ressourceId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.delete(
      Uri.parse('$baseUrl/ressources/$ressourceId'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        }
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
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.delete(
      Uri.parse('$baseUrl/utilisateur/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      }
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Failed to delete utilisateur: ${response.statusCode}');
      print('Reason: ${response.body}');
      return null;
    }
  }

  Future<bool> updateUser(int id, String nom, String prenom, String email) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.put(
      Uri.parse('$baseUrl/utilisateur/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
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
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.get(
      Uri.parse('$baseUrl/utilisateur/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Utilisateur.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load user from API');
    }
  }

  Future<List<Commentaire>> fetchComments(int ressourceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/commentaire/$ressourceId'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((c) => Commentaire.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load comments from API');
    }
  }

  void createComment(String texteCommentaire, int idUtilisateur,
      int idRessource, int commentaireResponse) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
      var requestBody = jsonEncode({
        'commentaire': texteCommentaire,
        'idCreateur': idUtilisateur,
        'idRessource': idRessource,
        'dateDeCreation': formattedDate,
        'idCommentaireRep': commentaireResponse
      });

      final response = await http.post(
        Uri.parse('$baseUrl/commentaire'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = json.decode(response.body);
      } else {
        print(
            'Failed to post comment. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error during comment creation: $e');
    }
  }

  Future<Categorie?> createCat(String nom) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
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
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.post(
      Uri.parse('$baseUrl/tags'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
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
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.post(
      Uri.parse('$baseUrl/types'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
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

  Future<List<int>> fetchFavoris(int? id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.get(
      Uri.parse('$baseUrl/favori/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<int> ids =
          jsonResponse.map((u) => u['id_ressource'] as int).toList();
      return ids;
    } else {
      throw Exception('Failed to load favorite resource IDs from API');
    }
  }

  Future<bool> createFavorite(int userId, int resourceId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.post(
      Uri.parse('$baseUrl/favori'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_utilisateur': userId,
        'id_ressource': resourceId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error status code: ${response.statusCode}');
      print('Error body: ${response.body}');
      return false;
    }
  }

  Future<List<TinyRessource>> fetchRessourcesByCreateur(int createurId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/ressources/byCreateur/$createurId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TinyRessource.fromJson(data)).toList();
    } else {
      throw Exception(
          'Failed to load resources for creator ID $createurId from API');
    }
  }

  Future<bool> isFavorite(int resourceId, int userId) async {
    try {
      List<int> favoriteIds = await fetchFavorie(userId);
      return favoriteIds.contains(resourceId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  Future<bool> toggleFavorite(int userId, int resourceId) async {
    bool isCurrentlyFavorite = await isFavorite(resourceId, userId);
    if (isCurrentlyFavorite) {
      // If it is currently a favorite, call delete favorite
      return await deleteFavorite(userId, resourceId);
    } else {
      // If it is not a favorite, call create favorite
      return await createFavorite(userId, resourceId);
    }
  }

  Future<bool> deleteFavorite(int userId, int resourceId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> user = jsonDecode(token!);
    String accessToken = user['accessToken'];
    final response = await http.delete(
      Uri.parse('$baseUrl/favori'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_utilisateur': userId,
        'id_ressource': resourceId,
      }),
    );
    return response.statusCode == 200;
  }

  // Check if a relation exists
  Future<bool> checkRelation(int currentUserID, int otherUserID) async {
    final response = await http
        .get(Uri.parse('$baseUrl/relation/check/$currentUserID/$otherUserID'));
    if (response.statusCode == 200) {
      return response.body.toLowerCase() ==
          'true'; // Assuming API returns 'true' or 'false'
    } else {
      return false;
    }
  }

  Future<bool> createRelation(int currentUserID, int otherUserID, int relationTypeID) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final response = await http.post(
      Uri.parse('$baseUrl/relation'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id_utilisateur1': currentUserID,
        'id_utilisateur2': otherUserID,
        'id_type_relation': relationTypeID,
      }),
    );
    return response.statusCode == 200;
  }

  // In ApiService.dart
  Future<bool> checkRelationExists(int userId1, int userId2) async {
    final response =
        await http.get(Uri.parse('$baseUrl/relation/exists/$userId1/$userId2'));
    if (response.statusCode == 200) {
      print("relation entre ${userId1} et ${userId2}");
      print(json.decode(response.body));
      return json.decode(response.body) as bool;
    } else {
      throw Exception('Failed to check relation existence');
    }
  }

// Add to ApiService.dart
  Future<List<TypesRelation>> fetchRelationTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/typesrelation'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((type) => TypesRelation.fromJson(type)).toList();
    } else {
      throw Exception('Failed to load relation types from API');
    }
  }

  Future<void> updateUserStatus(int userId, String newStatus) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      Map<String, dynamic> user = jsonDecode(token!);
      String accessToken = user['accessToken'];
      final response = await http.put(
        Uri.parse('$baseUrl/utilisateur/statu/$userId'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'statu': newStatus,
        }),
      );
      print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception('Failed to update user status');
      }
    } catch (e) {
      print('Failed to update user status: $e');
    }
  }

  Future<List<Relation>> fetchRelationsByUserId(int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/relation/user/$userId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Relation.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load relations: ${response.statusCode}');
    }
  }
}
