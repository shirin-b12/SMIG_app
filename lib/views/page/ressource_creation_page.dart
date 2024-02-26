import 'package:flutter/material.dart';
import 'package:smig_app/views/page/ressource_list_page.dart';
import '../../services/auth_service.dart';
import 'login_page.dart';

class RessourceCreationPage extends StatelessWidget {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final DateTime creationDateController = DateTime.now();
  final TextEditingController viewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer une ressource')),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: () async {
                final ressource = await AuthService().createRessource(
                  titleController.text,
                  descriptionController.text,
                  creationDateController,
                );
                if (ressource != null) {
                  print("OKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RessourceListPage()));
                } else {
                  // Afficher une erreur
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Échec de la création de la ressource")));
                }
              },
              child: Text('Créer une ressource'),
            ),
          ],
        ),
      ),
    );
  }
}

