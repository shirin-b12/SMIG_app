import 'package:flutter/material.dart';
import '../../models/ressource.dart';
import '../../models/commentaire.dart';
import '../../models/utilisateur.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';
import '../../widgets/ressource_card.dart';
import '../../views/page/ressource_modification_page.dart';

class RessourcePage extends StatelessWidget {
  final ApiService api = ApiService();
  final AuthService auth = AuthService();
  final int resourceId;

  RessourcePage({required this.resourceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF03989E),
        onPressed: () => _showAddCommentSheet(context),
        child: Icon(Icons.add_comment),
      ),
      body: FutureBuilder<Ressource>(
        future: api.getRessource(resourceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return _buildRessourceDetails(context, snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildRessourceDetails(BuildContext context, Ressource ressource) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          RessourceCard(ressource: ressource),
          FutureBuilder<List<Commentaire>>(
            future: api.fetchComments(ressource.id),
            builder: (context, snapshot) {
              print("oui${ressource.id}");
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: snapshot.data!.map((comment) => ListTile(
                      title: Text(comment.utilisateurRedacteur?.nom ?? 'Anonymous'),
                      subtitle: Text(comment.commentaire),
                    )).toList(),
                  );
                } else {
                  return Text("No comments found.");
                }
              } else if (snapshot.hasError) {
                return Text("Error fetching comments: ${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
          FutureBuilder<Utilisateur?>(
            future: auth.getCurrentUserDetails(),
            builder: (context, snapshotUser) {
              if (snapshotUser.connectionState == ConnectionState.done && snapshotUser.hasData) {
                bool isEditable = (snapshotUser.data!.role == 'Admin' ||
                    snapshotUser.data!.role == 'Moderateur' ||
                    snapshotUser.data!.id == ressource.createur.id);
                return Visibility(
                  visible: isEditable,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Color(0xFF03989E)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RessourceUpdatePage(ressourceId: resourceId),
                          ));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDeletion(context, ressource.id),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }

  void _showAddCommentSheet(BuildContext context) {
    TextEditingController commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Votre commentaire',
                  labelStyle: TextStyle(color: Color(0xFF015E62)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF03989E)),
                  ),
                ),
                maxLines: null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF03989E),
                ),
                child: Text('Envoyer'),
                onPressed: () async {
                  if (commentController.text.isNotEmpty) {
                    int userId = await AuthService().getCurrentUser();
                    try {
                      api.createComment(commentController.text, userId, resourceId, 0);
                      Navigator.pop(context); // Close the modal bottom sheet
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Commentaire ajouté avec succès!'))
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Échec de l\'ajout du commentaire: $e'))
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Le commentaire ne peut pas être vide.'))
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeletion(BuildContext context, int ressourceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this resource?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                api.deleteRessource(ressourceId);
              },
            ),
          ],
        );
      },
    );
  }
}
