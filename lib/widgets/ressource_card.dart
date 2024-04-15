import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../models/ressource.dart';
import 'package:expandable_text/expandable_text.dart';

class RessourceCard extends StatelessWidget {
  final Ressource ressource;
  final ApiService api = ApiService();
  RessourceCard({required this.ressource});

  @override
  Widget build(BuildContext context) {
    String formatShortDate(String date) {
      final DateTime parsedDate = DateFormat('dd/MM/yyyy HH:mm:ss').parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    }

    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: ressource.createur.pic != null
                    ? api.fetchImage(ressource.createur.pic as String)
                    : null,
                builder:
                    (BuildContext context, AsyncSnapshot<Image?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
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
              IconButton(
                icon: const Icon(Icons.star),
                onPressed: () {
                  // Handle button press here
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
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
                ),
                Text(
                  ressource.description,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ExpandableText(
                      ressource.description,
                      expandText: 'plus',
                      collapseText: 'moins',
                      maxLines: 3,
                      linkColor: Colors.blue,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                      collapseOnTextTap: true,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tags: ${ressource.tags.nom}',
                      style: const TextStyle(
                        color: Color(0xFF015E62),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Date de publication: ${formatShortDate(ressource.date_de_creation)}',
                      style: const TextStyle(
                        color: Color(0xFF015E62),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    // Replace this with your actual tags widget
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
