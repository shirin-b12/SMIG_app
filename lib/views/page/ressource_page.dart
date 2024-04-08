import 'package:flutter/material.dart';
import 'package:smig_app/services/auth_service.dart';
import '../../models/commentaire.dart';
import '../../models/ressource.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';
import '../../widgets/ressource_card.dart';

class RessourcePage extends StatelessWidget {
  final ApiService api = ApiService();
  final int resourceId;

  RessourcePage({required this.resourceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      floatingActionButton: FloatingActionButton(
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
                      decoration: InputDecoration(labelText: 'Votre commentaire'),
                    ),
                    ElevatedButton(
                      child: Text('Envoyer'),
                      onPressed: () async {
                        int userId = await AuthService().getCurrentUser();
                        print(userId);
                        print(resourceId);
                        print(commentController.text);
                        await api.createComment(commentController.text, userId, resourceId);
                        Navigator.pop(context);
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
                                    title:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${comment.idUtilisateurRedacteur.nom} ${comment.idUtilisateurRedacteur.prenom}"),
                                        Text(comment.commentaire),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Posted on: ${comment.dateDeCreation}"),
                                      ],
                                    ),
                                  )).toList(),
                                );
                              } else if (snapshotComments.hasError) {
                                return Text("Erreur: ${snapshotComments.error}");
                              }
                            }
                            return Center(child: CircularProgressIndicator());
                          },
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
}
