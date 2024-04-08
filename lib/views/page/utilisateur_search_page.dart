import 'package:flutter/material.dart';

import 'package:smig_app/models/categorie.dart';
import 'package:smig_app/models/ressource.dart';
import 'package:smig_app/services/api_service.dart';
import 'package:smig_app/models/utilisateur.dart';
import 'package:smig_app/models/type.dart';

import '../../models/tag.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

enum SearchCategory { Users, Resources, Categories, Types, Tags }

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Utilisateur> _allUsers = [];
  List<Ressource> _allRessources = [];
  List<Categorie> _allCategories = [];
  List<Type> _allTypes = [];
  List<Tag> _allTags = [];
  List<dynamic> _filteredItems = [];
  bool _isLoading = true;
  SearchCategory _selectedCategory = SearchCategory.Users;

  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _filteredItems = [];
        });
      } else {
        _filterItems(_controller.text);
      }
    });
    _loadItems();
  }


  _loadItems() async {
    if (_controller.text.isNotEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      switch (_selectedCategory) {
        case SearchCategory.Users:
          _allUsers = await api.fetchUtilisateurs();
          break;
        case SearchCategory.Resources:
          _allRessources = await api.fetchRessources();
          break;
        case SearchCategory.Categories:
          _allCategories = await api.fetchCategories();
          break;
        case SearchCategory.Types:
          _allTypes = await api.fetchTypes();
          break;
        case SearchCategory.Tags:
          _allTags = await api.fetchTags();
          break;
      }
    } catch (e) {
      //TODO : Gestion exception
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredItems = [];
      });
      return;
    }

    List<dynamic> tempFilteredItems = [];
    switch (_selectedCategory) {

      case SearchCategory.Users:
        tempFilteredItems = _allUsers.where((user) {
          return user.nom.toLowerCase().contains(query.toLowerCase()) ||
              user.prenom.toLowerCase().contains(query.toLowerCase());
        }).toList();
        break;

      case SearchCategory.Resources:
        tempFilteredItems = _allRessources.where((resource) {
          return resource.titre.toLowerCase().contains(query.toLowerCase()) ||
              resource.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
        break;

      case SearchCategory.Categories:
        tempFilteredItems = _allCategories.where((categorie) {
          return categorie.nom.toLowerCase().contains(query.toLowerCase());
        }).toList();
        break;

      case SearchCategory.Types:
        tempFilteredItems = _allTypes.where((type) {
          return type.nom.toLowerCase().contains(query.toLowerCase());
        }).toList();
        break;

      case SearchCategory.Tags:
        tempFilteredItems = _allTags.where((tag) {
          return tag.nom.toLowerCase().contains(query.toLowerCase());
        }).toList();
        break;
    }

    setState(() {
      _filteredItems = tempFilteredItems;
    });
  }



  void _changeSearchCategory(SearchCategory category) {
    setState(() {
      _selectedCategory = category;
      _isLoading = true;
    });
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              onChanged: (value) => _filterItems(value),
              cursorColor: Color(0xFF03989E),
              decoration: InputDecoration(
                labelText: "Recherche",
                labelStyle: TextStyle(
                  color: Color(0xFF03989E),
                ),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _filterItems('');
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF03989E),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF03989E),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF03989E),
                    width: 2.0,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: _buildCategoryButton(SearchCategory.Users, "Utilisateurs")),
                Expanded(child: _buildCategoryButton(SearchCategory.Resources, "Ressources")),
                Expanded(child: _buildCategoryButton(SearchCategory.Categories, "Catégories")),
                Expanded(child: _buildCategoryButton(SearchCategory.Types, "Types")),
                Expanded(child: _buildCategoryButton(SearchCategory.Tags, "Tags")),
              ],
            ),
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];

                switch (_selectedCategory) {
                  case SearchCategory.Users:
                  // Afficher un utilisateur
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFFFBD59),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ListTile(
                        title: Text("${item.nom} ${item.prenom}"),
                        subtitle: Text(item.email),
                        onTap: () {},
                      ),
                    );
                  case SearchCategory.Resources:
                  // Afficher une ressource
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFFFBD59),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ListTile(
                        title: Text(item.titre),
                        onTap: () {},
                      ),
                    );
                  case SearchCategory.Categories:
                  case SearchCategory.Types:
                  case SearchCategory.Tags:
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFFFBD59),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ListTile(
                        minLeadingWidth: 10,
                        title: Text(
                          item.nom,
                          style: const TextStyle(
                            color: Color(0xFF015E62),
                          ),
                        ),
                        onTap: () {},
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(SearchCategory category, String title) {
    bool isSelected = _selectedCategory == category;

    return ElevatedButton(
      onPressed: () => _changeSearchCategory(category),
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Color(0xFF8BBFC2) : Colors.white,
        onPrimary: isSelected ? Colors.white : Color(0xFF03989E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: const BorderSide(
            color: Color(0xFF03989E),
            width: 0.1,
          ),
        ),
        elevation: 0,
        textStyle: TextStyle(
          color: isSelected ? Colors.white : Color(0xFF03989E),
          fontSize: 16,
        ),
      ),
      child: Text(title),
    );
  }


}

