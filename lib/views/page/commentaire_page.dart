import 'package:flutter/material.dart';
import '../../models/commentaire.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class CommentsPage extends StatelessWidget {
  final int ressourceId;
  final ApiService api = ApiService();

  CommentsPage({Key? key, required this.ressourceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      body: FutureBuilder<List<Commentaire>>(
        future: api.fetchComments(28),//ressourceId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final comment = snapshot.data![index];
                  return ListTile(
                    title:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${comment.utilisateurRedacteur?.nom} ${comment.utilisateurRedacteur?.prenom}"),
                        Text(comment.commentaire),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Posted on: ${comment.dateDeCreation}"),
                      ],
                    ),
                   // isThreeLine: true,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
