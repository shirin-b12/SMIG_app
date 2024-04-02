import 'package:flutter/material.dart';
import 'package:smig_app/services/api_service.dart';
import 'package:smig_app/models/utilisateur.dart';

import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class UserModificationPage extends StatefulWidget {
  final Utilisateur user;

  const UserModificationPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserModificationPageState createState() => _UserModificationPageState();
}

class _UserModificationPageState extends State<UserModificationPage> {
  final _formKey = GlobalKey<FormState>();
  late String nom, prenom, email;
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    nom = widget.user.nom;
    prenom = widget.user.prenom;
    email = widget.user.email;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool updated = await api.updateUser(/*widget.user.id*/5, nom, prenom, email);
      print("is clicked");
      if (updated) {
        Navigator.pop(context, true);
      } else {
        //TODO : Handle update error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: nom,
              decoration: const InputDecoration(labelText: "Nom"),
              onSaved: (value) => nom = value!,
              validator: (value) => value!.isEmpty ? "Veuillez entrer votre nom " : null,
            ),
            TextFormField(
              initialValue: prenom,
              decoration: const InputDecoration(labelText: "Prénom"),
              onSaved: (value) => prenom = value!,
              validator: (value) => value!.isEmpty ? "Veuillez entrer votre prénom " : null,
            ),
            TextFormField(
              initialValue: email,
              decoration: const InputDecoration(labelText: "Email"),
              onSaved: (value) => email = value!,
              validator: (value) => value!.isEmpty ? "Veuillez entrer votre adresse e-mail " : null,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Soumettre'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
