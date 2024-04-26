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
                            builder: (context) => RessourcePage(ressourceId: ressource.id),
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
