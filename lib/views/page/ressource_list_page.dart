import 'package:flutter/material.dart';
import 'package:smig_app/views/page/signup_page.dart';
import 'package:flutter/rendering.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';
import '../../widgets/ressource_card.dart';
import '../../models/ressource.dart';
import '../../widgets/custom_app_bar.dart';
import 'login_page.dart';

class RessourceListPage extends StatelessWidget {
  final ApiService api = ApiService();

  RessourceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: const CustomTopAppBar(),
      bottomNavigationBar: const CustomBottomAppBar(),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: api.fetchRessources(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => RessourceSimplifiedCard(ressource: snapshot.data[index]),
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

class RessourceSimplifiedCard extends StatelessWidget {
  final Ressource ressource;

  RessourceSimplifiedCard({required this.ressource});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: ListTile(
        title: Text(
          ressource.titre,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF007FFF),
          ),
        ),
        subtitle: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 300,
                  child: Text(
                    ressource.description,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  ressource.getDateWithoutSeconds(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF549837),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}