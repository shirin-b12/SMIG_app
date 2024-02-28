import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/ressource.dart';

class RessourceCard extends StatelessWidget {
  final Ressource ressource;

  RessourceCard({required this.ressource});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: ListTile(
        title: Text(
          ressource.titre,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF007FFF),
          ),
        ),
        subtitle: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10.0, 0, 5),
              child: Row(
                children: [
                  Container(
                    width: 300,
                    child: Text(
                      ressource.description,
                      overflow: TextOverflow.ellipsis,

                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Row(
                children: [
                  Text(
                    ressource.getDateWithoutSeconds(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF549837),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
