import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../models/ressource.dart';
import '../widgets/confirmationRessourceDialog.dart';

class RessourceCard extends StatelessWidget {
  final Ressource ressource;
  final ApiService api = ApiService();
  Future<int> fetchUserId() async {
    int? userId = await AuthService().getCurrentUser();
    return userId ?? 0; // return 0 or a default user ID if userId is null
  }

  Future<String> fetchUserRole() async {
    String? role = await AuthService().getCurrentUserRole();
    return role ?? '';
    print(role);
  }

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
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                //backgroundImage: ressource.createur.pic != null ? NetworkImage(ressource.createur.pic as String) : null,
                child: ressource.createur.pic == null
                    ? const Icon(Icons.image, color: Color(0xFF03989E))
                    : null,
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
              FutureBuilder<int>(
                future: fetchUserId(),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    return IconButton(
                      icon: FutureBuilder<bool>(
                        future: api.isFavorite(
                            ressource.id.toString(), snapshot.data.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          if (snapshot.hasData && snapshot.data == true) {
                            return Icon(Icons.star);
                          } else {
                            return Icon(Icons.star_border);
                          }
                        },
                      ),
                      onPressed: () {
                        // Handle button press here
                      },
                    );
                  } else {
                    return CircularProgressIndicator(); // Show a loading spinner while waiting for fetchUserId to complete
                  }
                },
              )
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
                        child: //ressource.images.fichier == null
                            //?
                            const Icon(Icons.image, color: Color(0xFFFFFFFF))
                        /*: FutureBuilder<Uint8List>(
                              future: api.compressImage(
                                  api.convertToFile(ressource.images.fichier)),
                              builder: (BuildContext context,
                                  AsyncSnapshot<Uint8List> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Icon(Icons.error);
                                } else {
                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                  );
                                }
                              },
                            ),*/
                        ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    /*child: ExpandableText(
                      ressource.description,
                      expandText: 'plus',
                      collapseText: 'moins',
                      maxLines: 10,
                      linkColor: Colors.blue,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                      collapseOnTextTap: true,
                    ),*/
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
                FutureBuilder<String>(
                  future: fetchUserRole(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData && snapshot.data == 'Modérateur') {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            ressource?.validate_ressource ?? false
                                ? const Color.fromARGB(255, 2, 170, 8)
                                : const Color.fromARGB(255, 204, 18, 5),
                          ),
                        ),
                        onPressed: () {
                          print(ressource ?? 'Ressource is null');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmationRessourceDialog(
                                ressourceId: ressource.id,
                                reponce: !ressource.validate_ressource,
                              ); // Use the new widget here
                            },
                          );
                        },
                        child: Text(
                            ressource?.validate_ressource ?? false
                                ? 'Valider'
                                : 'Bloquer',
                            style: TextStyle(color: Colors.white)),
                      );
                    } else {
                      return Container(); // Return an empty container if the user is not a 'Modérateur'
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
