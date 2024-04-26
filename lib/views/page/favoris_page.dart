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
          ? ListView.builder(
        itemCount: ressources!.length,
        itemBuilder: (context, index) {
          TinyRessource ressource = ressources![index];
          return ListTile(
            title: Text(ressource.titre),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RessourcePage(ressourceId: ressource.id),
              ),
            ),
          );
        },
      )
          : const Center(child: Text("No favorites available")),
    );
  }
}
