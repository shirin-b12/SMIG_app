import 'package:flutter/material.dart';
import 'package:smig_app/services/auth_service.dart';
import 'package:smig_app/views/page/ressource_modification_page.dart';
import '../../models/commentaire.dart';
import '../../models/ressource.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';
import '../../widgets/ressource_card.dart';

class RessourcePage extends StatelessWidget {
  final ApiService api = ApiService();
  final int ressourceId;

  RessourcePage({required this.ressourceId});

  @override
  Widget build(BuildContext context) {
    // Define the theme colors
    final Color primaryColor = Color(0xFF03989E);
    final Color secondaryColor = Color(0xFF015E62);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor, // Use primary color here
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              final TextEditingController commentController = TextEditingController();
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        labelText: 'Votre commentaire',
                        labelStyle: TextStyle(color: secondaryColor), // Use secondary color for label
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor), // Use primary color for focus
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: primaryColor, // Text color
                      ),
                      child: Text('Envoyer'),
                      onPressed: () async {
                        int userId = await AuthService().getCurrentUser();
                        api.createComment(commentController.text, userId, resourceId, 0);
                        api.fetchComments(resourceId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add_comment),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Ressource>(
              future: api.getRessource(resourceId),
              builder: (context, snapshotRessource) {
                if (snapshotRessource.connectionState == ConnectionState.done) {
                  if (snapshotRessource.hasData) {
                    return ListView(
                      children: <Widget>[
                        RessourceCard(ressource: snapshotRessource.data!),
                        FutureBuilder<List<Commentaire>>(
                          future: api.fetchComments(resourceId),
                          builder: (context, snapshotComments) {
                            if (snapshotComments.connectionState == ConnectionState.done) {
                              if (snapshotComments.hasData) {
                                return Column(
                                  children: snapshotComments.data!.map((comment) => ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${comment.utilisateurRedacteur?.nom} ${comment.utilisateurRedacteur?.prenom}",
                                            style: TextStyle(color: secondaryColor)),
                                        Text(comment.commentaire),
                                      ],
                                    ),
                                    subtitle: Text("Posted on: ${comment.dateDeCreation}",
                                        style: TextStyle(fontSize: 10)),
                                  )).toList(),
                                );
                              } else if (snapshotComments.hasError) {
                                return Text("Erreur: ${snapshotComments.error}");
                              }
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                        SizedBox(height: 50),
                        Container(
                          width: 250,
                          height: 30,
                          child: Center(
                            child: _buildModifyButton(context, snapshotRessource.data!),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshotRessource.hasError) {
                    return Text("Erreur: ${snapshotRessource.error}");
                  }
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModifyButton(BuildContext context, Ressource ressource) {
    return FutureBuilder<int>(
      future: AuthService().getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final int currentUserId = snapshot.data!;
            // Vérifie si l'utilisateur actuel est le créateur de la ressource
            bool isCreator = currentUserId == ressource.createur.id;

            // Si l'utilisateur actuel est le créateur de la ressource, affichez le bouton de modification
            if (isCreator) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RessourceUpdatePage(ressource: ressource),
                    ),
                  );
                },
                child: Text('Modifier la ressource'),
              );
            }
          } else if (snapshot.hasError) {
            // Gestion de l'erreur s'il y a eu un problème lors de la récupération de l'ID de l'utilisateur
            print("Erreur lors de la récupération de l'ID de l'utilisateur: ${snapshot.error}");
          }
        }
        // Si le Future n'est pas encore résolu, ou s'il n'y a pas de données, retournez un conteneur vide
        return Container();
      },
    );
  }
}
