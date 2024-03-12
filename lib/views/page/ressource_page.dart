import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/ressource_card.dart';
import '../../models/ressource.dart';

class RessourcePage extends StatelessWidget {
  final ApiService api = ApiService();
  final int ressourceId;

  RessourcePage({required this.ressourceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Ressource>(
        future: api.getRessource(ressourceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[
                  RessourceCard(ressource: snapshot.data!),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () async => await api.deleteRessource(ressourceId),
                    child: Text('Supprimer'),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
