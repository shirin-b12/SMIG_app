import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/utilisateur.dart';

class ApiService {
  Future<List<Utilisateur>> fetchUtilisateurs() async {
    final response = await http.get(Uri.parse('http://localhost:8081/utilisateur'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((u) => Utilisateur.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load users from API');
    }
  }
}
