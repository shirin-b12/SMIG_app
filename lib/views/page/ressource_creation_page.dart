import 'package:flutter/material.dart';
import 'package:smig_app/services/api_service.dart';
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
        padding: EdgeInsets.all(20.0),
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
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () async {
                  final ressource = await ApiService().createRessource(
                    titleController.text,
                    descriptionController.text
                  );

                  if (ressource != null) {
                    print("OKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RessourceListPage()));
                  }
                  else if (titleController.text == "" || descriptionController.text == ""){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Veuillez remplir tout les champs nécessaires")));
                  }
                  else {
                    // Afficher une erreur
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Échec de la création de la ressource")));
                  }
                },
                child: Text('Créer une ressource'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

