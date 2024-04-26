import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/utilisateur.dart';
import 'package:jwt_decode/jwt_decode.dart';

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

  Future<bool> createAccount(
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
        'mot_de_passe': password
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String tokenData = prefs.getString('userToken') ?? '';
    tokenData = tokenData.trim();

    if (tokenData.isNotEmpty) {
      try {
        Map<String, dynamic> tokenJson = jsonDecode(tokenData);
        String accessToken = tokenJson['accessToken'];
        if (accessToken.isNotEmpty) {
          Map<String, dynamic> payload = Jwt.parseJwt(accessToken);
          int userId = int.parse(payload['upn']);
          return userId;
        } else {
          print("AccessToken is empty or not found.");
          return 0;
        }
      } catch (e) {
        print("Error parsing token or accessing user ID: $e");
        return 0;
      }
    } else {
      print("No token found");
      return 0;
    }
  }

  Future<String> getCurrentUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    String tokenData = prefs.getString('userToken') ?? '';
    tokenData = tokenData.trim();

    if (tokenData.isNotEmpty) {
      try {
        Map<String, dynamic> tokenJson = jsonDecode(tokenData);
        String accessToken = tokenJson['accessToken'];
        if (accessToken.isNotEmpty) {
          Map<String, dynamic> payload = Jwt.parseJwt(accessToken);
          List<dynamic> userRoles = payload['groups'];
          if (userRoles.isNotEmpty) {
            String userRole = userRoles[0];
            return userRole;
          } else {
            print("No roles found for the user.");
            return '';
          }
        } else {
          print("AccessToken is empty or not found.");
          return '';
        }
      } catch (e) {
        print("Error parsing token or accessing user role: $e");
        return '';
      }
    } else {
      print("No token found");
      return '';
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

  Future<Utilisateur?> getCurrentUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String tokenData = prefs.getString('userToken') ?? '';
    tokenData = tokenData.trim();

    Map<String, dynamic> tokenJson = jsonDecode(tokenData);
    String accessToken = tokenJson['accessToken'];

    if (accessToken != null) {
      Map<String, dynamic> payload = Jwt.parseJwt(accessToken);
      int userId = int.parse(payload['upn']);
      final response =
          await http.get(Uri.parse('$baseUrl/utilisateur/$userId'));
      if (response.statusCode == 200) {
        return Utilisateur.fromJson(json.decode(response.body));
      }
    }
    return null;
  }
}
