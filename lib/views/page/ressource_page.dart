import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/ressource_card.dart';

class RessourcePage extends StatelessWidget {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: api.fetchRessource(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => RessourceCard(ressource: snapshot.data[index]),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}