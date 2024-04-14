import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../services/api_service.dart';
import '../models/ressource.dart';

class RessourceCard extends StatelessWidget {
  final Ressource ressource;
  final ApiService api = ApiService();
  RessourceCard({required this.ressource});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder(
                  future: this.ressource.createur.pic != null
                      ? api.fetchImage(this.ressource.createur.pic as String)
                      : null,
                  builder:
                      (BuildContext context, AsyncSnapshot<Image?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Icon(Icons.error);
                    } else {
                      return CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: snapshot.data != null
                            ? snapshot.data!.image as ImageProvider
                            : null,
                        child: snapshot.data == null
                            ? const Icon(Icons.image, color: Color(0xFF03989E))
                            : null,
                      );
                    }
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${ressource.createur.nom} ${ressource.createur.prenom}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF015E62),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                ressource.titre,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF015E62),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Catégorie: ${ressource.category.nom}",
                  style: const TextStyle(
                    color: Color(0xFF015E62),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "Type: ${ressource.type.nom}",
                  style: const TextStyle(
                    color: Color(0xFF015E62),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  height: 70.0,
                  width: 70.0,
                  color: Color(0xFF03989E),
                  child: ressource.image == null
                      ? const Icon(Icons.image, color: Color(0xFFFFFFFF))
                      : null,
                ),
              ),
            ),
            Text(
              ressource.description,
              style: const TextStyle(
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
