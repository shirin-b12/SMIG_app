import 'package:flutter/material.dart';
import 'package:smig_app/views/page/signup_page.dart';
import 'package:smig_app/widgets/custom_top_app_bar.dart';
import '../../services/api_service.dart';
import '../../widgets/utilisateur_card.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: api.fetchUtilisateurs(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => UtilisateurCard(utilisateur: snapshot.data[index]),
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
