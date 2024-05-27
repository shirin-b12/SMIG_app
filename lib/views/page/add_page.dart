import 'package:flutter/material.dart';
import 'package:smig_app/services/auth_service.dart';
import 'package:smig_app/views/page/ressource_creation_page.dart';

import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';
import 'create_tag_cat_type.dart';
import 'create_user_with_role.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String? role;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  void _fetchUserRole() async {
    role = await AuthService().getCurrentUserRole();
    if (role == "Utilisateur" || role == "Anonyme") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RessourceCreationPage()));
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (role == "Utilisateur" || role == "Anonyme") {
      return Container();
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomTopAppBar(),
        bottomNavigationBar: CustomBottomAppBar(),
        body: ListView(
          children: <Widget>[
            _buildNavigationButton("Créer une Ressource", RessourceCreationPage()),
            _buildNavigationButton("Créer un Utilisateur", CreateUserWithRolePage()),
            _buildNavigationButton("Créer un Type, Catégorie ou Tag", CreateCatTypeTag()),
          ],
        ),
      );
    }
  }

  Widget _buildNavigationButton(String title, Widget page) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
