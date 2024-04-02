import 'package:flutter/material.dart';
import 'package:smig_app/services/api_service.dart';
import 'package:smig_app/models/utilisateur.dart';

import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Utilisateur> _allUsers = [];
  List<Utilisateur> _filteredUsers = [];
  bool _isLoading = true;

  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  _loadUsers() async {
    _allUsers = await api.fetchUtilisateurs();
    setState(() => _isLoading = false);
  }

  void _filterUsers(String query) {
    if(query.isEmpty) {
      setState(() {
        _filteredUsers = List.from(_allUsers);
      });
      return;
    }

    List<Utilisateur> tempFilteredUsers = _allUsers.where((user) {
      return user.nom.toLowerCase().contains(query.toLowerCase()) || user.prenom.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredUsers = tempFilteredUsers;
    });
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
              onChanged: (value) => _filterUsers(value),
              decoration: InputDecoration(
                labelText: "Recherche un utilisateur avec son Nom ou Prénom",
                suffixIcon: _controller.text.isEmpty ? null : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _filterUsers('');
                  },
                ),
              ),
            ),
          ),
          _isLoading ? const CircularProgressIndicator() : Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return ListTile(
                  title: Text("${user.nom} ${user.prenom}"),
                  subtitle: Text(user.email),
                  onTap: () {
                    // TODO : gestion de recherche
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
