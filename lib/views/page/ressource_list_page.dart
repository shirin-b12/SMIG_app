import 'package:flutter/material.dart';
import 'package:smig_app/models/ressource.dart';
import 'package:smig_app/services/api_service.dart';
import 'package:smig_app/views/page/ressource_page.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class RessourceListPage extends StatelessWidget {
  final ApiService api = ApiService();

  RessourceListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomTopAppBar(),
      bottomNavigationBar: const CustomBottomAppBar(),
      body: FutureBuilder<List<Ressource>>(
        future: api.fetchRessources(),
        builder: (BuildContext context, AsyncSnapshot<List<Ressource>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Erreur : ${snapshot.error}");
          } else if (snapshot.hasData) {
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Ressource ressource = snapshot.data![index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RessourcePage(resourceId: ressource.id),
                      ),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: ListTile(
                        title: Text(
                          ressource.titre,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF007FFF),
                          ),
                        ),
                        subtitle: Text(
                          ressource.description,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text("Aucune donnée disponible"));
          }
        },
      ),
    );
  }
}
