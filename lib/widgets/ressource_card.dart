import 'package:flutter/material.dart';
import '../models/ressource.dart';

class RessourceCard extends StatelessWidget {
  final Ressource ressource;

  RessourceCard({required this.ressource});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(ressource.titre),
        subtitle: Text(ressource.description + "\n" + ressource.date_de_creation),
      ),
    );
  }
}
