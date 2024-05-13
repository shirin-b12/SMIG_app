import 'package:flutter/material.dart';
import 'package:smig_app/services/api_service.dart';
import 'package:smig_app/services/auth_service.dart';
import 'package:smig_app/views/page/ressource_page.dart';
import '../../models/tiny_ressource.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class FavorisListPage extends StatefulWidget {
  FavorisListPage({Key? key}) : super(key: key);

  @override
  _FavorisListPageState createState() => _FavorisListPageState();
}

class _FavorisListPageState extends State<FavorisListPage> {
  int? userId;
  bool isLoading = true;
  List<TinyRessource>? ressources;

  @override
  void initState() {
    super.initState();
    _loadUserProfileAndFavorites();
  }

  Future<void> _loadUserProfileAndFavorites() async {
    int? id = await AuthService().getCurrentUser();
    if (id != null) {
      List<int> favoriteIds = await ApiService().fetchFavoris(id);
      List<TinyRessource> fetchedRessources = [];
      for (var resourceId in favoriteIds) {
        TinyRessource ressource = await ApiService().fetchTinyRessource(resourceId);
        fetchedRessources.add(ressource);
      }
      setState(() {
        userId = id;
        ressources = fetchedRessources;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomTopAppBar(),
      bottomNavigationBar: const CustomBottomAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ressources != null && ressources!.isNotEmpty
          ? Column(
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/gouv/marianne.png',
                  width: 40, height: 40),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: ressources!.length,
              itemBuilder: (context, index) {
                TinyRessource ressource = ressources![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RessourcePage(resourceId: ressource.id)),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ressource.titre,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF015E62),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Color(0xFF03989E)),
                          onPressed: () async {
                            bool success = await ApiService().deleteFavorite(userId!, ressource.id);
                            if (success) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => super.widget));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Favoris supprimé avec succès"),
                                  backgroundColor: Color(0xFFFFBD59),
                                  duration: const Duration(seconds: 2),
                                  shape: StadiumBorder(),
                                  behavior: SnackBarBehavior.floating));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Échec du suppression"),
                                  backgroundColor: Color(0xFFFFBD59),
                                  duration: const Duration(seconds: 2),
                                  shape: StadiumBorder(),
                                  behavior: SnackBarBehavior.floating));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )
          : const Center(child: Text("No favorites available")),
    );
  }

}
