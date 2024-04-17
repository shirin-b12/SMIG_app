import 'package:flutter/material.dart';
import '../../models/tiny_ressource.dart';
import '../../models/utilisateur.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Utilisateur? user;
  List<TinyRessource>? resources;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    int? userId = await AuthService().getCurrentUser();
    if (userId != null) {
      try {
        Utilisateur userDetails = await ApiService().getUtilisateur(userId);
        List<TinyRessource> userResources = await ApiService().fetchRessourcesByCreateur(userId);
        setState(() {
          user = userDetails;
          resources = userResources;
          isLoading = false;
        });
      } catch (e) {
        print('Error loading user or resources: $e');
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomTopAppBar(),
      bottomNavigationBar: const CustomBottomAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Color(0xFF03989E)),
                  onPressed: () {
                    print("Modif");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.menu, color: Color(0xFF03989E)),
                  onPressed: () {
                    print("param");
                  },
                ),
              ],
            ),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFF03989E),
                shape: BoxShape.circle,
                image: user?.pic != null ? DecorationImage(
                  image: NetworkImage(user!.getProfileImageUrl()),
                  fit: BoxFit.cover,
                ) : null,
              ),
              alignment: Alignment.center,
              child: user?.pic == null ? Icon(
                Icons.photo,
                size: 35.0,
                color: Colors.white,
              ) : null,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${user?.nom} ', style: TextStyle(color: Color(0xFF03989E))),
                  Text('${user?.prenom}', style: TextStyle(color: Color(0xFF03989E))),
                ],
              ),
            ),
            Text('Email: ${user?.email}'),
            Expanded(
              child: _buildResourcesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesList() {
    if (resources == null || resources!.isEmpty) {
      return Center(
        child: Text('No resources found for this user'),
      );
    } else {
      return ListView.builder(
        itemCount: resources!.length,
        itemBuilder: (context, index) {
          TinyRessource ressource = resources![index];
          return ListTile(
            title: Text(ressource.titre),
            onTap: () {
              // Optionally, add navigation or other interaction
              print('Tapped on resource: ${ressource.titre}');
            },
          );
        },
      );
    }
  }


}
