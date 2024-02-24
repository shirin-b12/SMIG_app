import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un compte')),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: surnameController,
              decoration: InputDecoration(labelText: 'Prénom'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                final utilisateur = await AuthService().createAccount(
                  nameController.text,
                  surnameController.text,
                  emailController.text,
                  passwordController.text,
                );
                if (utilisateur != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
                } else {
                  // Afficher une erreur
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Échec de la création de compte")));
                }
              },
              child: Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}

