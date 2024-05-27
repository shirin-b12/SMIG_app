import 'package:flutter/material.dart';
import 'package:smig_app/models/ressource.dart';
import 'package:smig_app/services/api_service.dart';
import 'package:smig_app/views/page/ressource_page.dart';
import 'package:smig_app/widgets/custom_bottom_app_bar.dart';
import 'package:smig_app/widgets/custom_top_app_bar.dart';
import 'package:smig_app/widgets/ressource_card.dart';

import '../screen/transition_page.dart';

class HomePage extends StatelessWidget {
  final ApiService api = ApiService();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      body: Column(
        children: <Widget>[
          Container(
            color : Colors.white,
            child : Row(
              children: [
                SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 15),
                    foregroundColor: Color(0xFF03989E),
                  ),
                  onPressed: () => print("la france tu l'aime ou tu la quitte "),
                  child: const Text('Général ▼', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,)),
                ),
                Spacer(),
                Image.asset('assets/gouv/marianne.png', width: 40, height: 40),
                SizedBox(width: 10),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: api.fetchRessources(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Ressource ressource = snapshot.data[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(CustomMaterialPageRoute(
                            builder: (context) => RessourcePage(resourceId: ressource.id),
                          ));
                        },
                        child: RessourceCard(ressource: ressource),
                      );
                    },
                  );

                } else {
                  return Text("Aucune donnée disponible");
                }
              },
            ),
          ),
        ],
      )
    );
  }
}
