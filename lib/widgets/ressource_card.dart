import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/ressource.dart';

class RessourceCard extends StatelessWidget {
  final Ressource ressource;

  RessourceCard({required this.ressource});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          ressource.titre,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10.0, 0, 5),
              child: Row(
                children: [
                  Text(ressource.description),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Row(
                children: [
                  Text(ressource.date_de_creation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
