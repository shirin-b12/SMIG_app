import 'package:flutter/material.dart';
import 'package:smig_app/views/page/signup_page.dart';
import '../../services/api_service.dart';
import '../../widgets/ressource_card.dart';
import '../../widgets/custom_app_bar.dart';
import 'login_page.dart';

class RessourceListPage extends StatelessWidget {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: api.fetchRessources(),
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