import 'package:flutter/material.dart';
import '../models/utilisateur.dart';

class UtilisateurCard extends StatelessWidget {
  final Utilisateur utilisateur;

  UtilisateurCard({required this.utilisateur});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(utilisateur.nom + " " + utilisateur.prenom),
        subtitle: Text(utilisateur.email),
      ),
    );
  }
}
