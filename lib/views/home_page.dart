import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/utilisateur_card.dart';

class HomePage extends StatelessWidget {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Utilisateurs')),
      body: FutureBuilder(
        future: api.fetchUtilisateurs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => UtilisateurCard(utilisateur: snapshot.data[index]),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
