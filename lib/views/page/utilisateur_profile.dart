import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'home_page.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    int? id = await AuthService().getCurrentUser();
    setState(() {
      userId = id;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Utilisateur'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : userId != null
            ? Text('ID de l\'utilisateur : $userId')
            : Text('Aucun utilisateur connecté ou token non trouvé.'),
      ),
    );
  }
}