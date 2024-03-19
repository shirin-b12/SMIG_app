import 'package:flutter/material.dart';
import 'package:smig_app/views/page/ressource_list_page.dart';
import 'package:smig_app/views/page/signup_page.dart';
import '../../services/api_service.dart';
import '../../widgets/utilisateur_card.dart';
import '../../widgets/custom_app_bar.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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
          ElevatedButton(
            onPressed: () => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RessourceListPage()))
            },
            child: Text("Liste Ressources", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
