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
            const SizedBox(height: 10),
            Row(
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
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  child: ressource.image,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  child: Text(
                    ressource.vue.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
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
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  child: Text(
                    ressource.visibilite.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
