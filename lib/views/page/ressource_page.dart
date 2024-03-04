import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/ressource_card.dart';
import '../../models/ressource.dart';

class RessourcePage extends StatelessWidget {
  final ApiService api = ApiService();
  final int resourceId;

  RessourcePage({required this.resourceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Ressource>(
        future: api.getRessource(resourceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[
                  RessourceCard(ressource: snapshot.data!),
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
