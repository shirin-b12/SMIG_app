import 'package:http/http.dart' as http;
import 'dart:convert';

class StatService {
  final String baseUrl = 'http://localhost:8081';

  Future<dynamic> fetchStatsByCategoryPerMonth() async {
    final response = await http.get(Uri.parse('$baseUrl/stat/admin/nombreDeRessoucesParCategoriesParMois'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch stats by category per month');
    }
  }

  Future<dynamic> fetchStatsByTagPerMonth() async {
    final response = await http.get(Uri.parse('$baseUrl/stat/admin/nombreDeRessoucesParTagParMois'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch stats by tag per month');
    }
  }

  Future<dynamic> fetchTopResourcesInFavorites() async {
    final response = await http.get(Uri.parse('$baseUrl/stat/admin/TopRessourceDansFavoris'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch top resources in favorites');
    }
  }

  Future<dynamic> fetchTopCreators() async {
    final response = await http.get(Uri.parse('$baseUrl/stat/admin/TopCreateur'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch top creators');
    }
  }
}
