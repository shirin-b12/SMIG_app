import 'package:flutter/material.dart';
import 'package:smig_app/views/page/utilisateur_modification_page.dart';
import '../../models/relation.dart';
import '../../models/tiny_ressource.dart';
import '../../models/utilisateur.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';
import '../../widgets/tiny_ressource_card.dart';
import '../../widgets/utilisateur_card.dart';
import '../screen/signup_or_login/signup_or_login.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Utilisateur? user;
  List<TinyRessource>? resources;
  List<Utilisateur>? allUsers;
  bool isLoading = true;
  String? role;
  int? userId;
  List<Relation>? relations;
  int relationsCount = 0;

  Future<void> _determineDisplay() async {
    role = await AuthService().getCurrentUserRole();
    if (role != null && role != "Utilisateur" && role != '') {
      await _loadAllUsers();
    } else {
      await _loadUserProfile();
    }
  }

  Future<void> _loadAllUsers() async {
    try {
      allUsers = await ApiService().fetchUtilisateurs();
      setState(() => isLoading = false);
    } catch (e) {
      print('Error loading all users: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _determineDisplay();
    _fetchRelations();
  }

  Future<void> _fetchRelations() async {

    userId = await AuthService().getCurrentUser();
    relations = await ApiService().fetchRelationsByUserId(userId!);
    relationsCount = relations?.length ?? 0;
    setState(() {});
  }

  Future<void> _loadUserProfile() async {
    userId = await AuthService().getCurrentUser();
    if (userId != null) {
      try {
        Utilisateur userDetails = await ApiService().getUtilisateur(userId!);
        List<TinyRessource> userResources = await ApiService().fetchRessourcesByCreateur(userId!);
        setState(() {
          user = userDetails;
          resources = userResources;
          isLoading = false;
        });
      } catch (e) {
        print('Error loading user or resources: $e');
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomTopAppBar(),
      bottomNavigationBar: const CustomBottomAppBar(),
      body: SafeArea(
        child: role != null && role != "Utilisateur" && role != 'Anonyme'
            ? _buildUserList()
            : _buildUserProfile(),
      ),
    );
  }

  Widget _buildResourcesList() {
    if (resources == null || resources!.isEmpty) {
      return const Center(
        child: Text('No resources found for this user'),
      );
    } else {
      return ListView.builder(
        itemCount: resources!.length,
        itemBuilder: (context, index) {
          TinyRessource ressource = resources![index];
          return TinyRessourceCard(ressource: ressource);
        },
      );
    }
  }


  Widget _buildUserProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Color(0xFF03989E)),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserModificationPage(user: user as Utilisateur)));
              },
            ),
            IconButton(
              icon: Icon(Icons.logout_outlined, color: Color(0xFF03989E)),
              onPressed: () {
                AuthService().logout();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpOrLogin()));
              },
            ),
          ],
        ),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Color(0xFF03989E),
            shape: BoxShape.circle,
            image: user?.pic != null ? DecorationImage(
              image: NetworkImage(user!.getProfileImageUrl()),
              fit: BoxFit.cover,
            ) : null,
          ),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (user?.pic == null)
                Icon(
                  Icons.photo,
                  size: 35.0,
                  color: Colors.white,
                ),

              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    print("Change photo tapped");
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFFFBD59),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Color(0xFF03989E),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '\n${user?.nom} \n',
                  style: const TextStyle(
                    color: Color(0xFF03989E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold, // Gras
                  )
              ),
              Text(
                  '\n${user?.prenom}\n',
                  style: const TextStyle(
                    color: Color(0xFF03989E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 15),
                foregroundColor: Color(0xFF03989E),
              ),
              onPressed: () => _showRelationsDialog(),
              child: Text('$relationsCount relations\n'),
            ),
            Text(
                '${resources?.length ?? 0} ressources\n',
                style: const TextStyle(
                  color: Color(0xFF03989E),
                  fontSize: 15,
                )
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.3,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFF03989E),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            "Vos ressources ",
            style: TextStyle(
              color: Color(0xFF03989E),
              fontSize: 15,
            ),
          ),
        ),

        Expanded(
          child: _buildResourcesList(),
        ),
      ],
    );
  }

  Widget _buildUserList() {
    if (allUsers == null || allUsers!.isEmpty) {
      return Center(child: Text('No users found'));
    }

    return ListView.builder(
      itemCount: allUsers!.length,
      itemBuilder: (context, index) {
        Utilisateur currentUser = allUsers![index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              backgroundImage: currentUser.pic != null
                  ? NetworkImage(currentUser!.getProfileImageUrl())
                  : null,
              child: currentUser.pic == null
                  ? const Icon(Icons.person, color: Color(0xFF03989E))
                  : null,
            ),
            title: Text('${currentUser.nom} ${currentUser.prenom}'),
            subtitle: Text('${currentUser.role} \n ${currentUser.email} '),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (role == "Moderateur")
                  IconButton(
                    icon: Icon(Icons.gavel, color: Colors.orange),
                    onPressed: () {
                      showStatusDialog(
                          context, currentUser.id, currentUser.etat);
                      print('Moderation action for ${currentUser.nom}');
                    },
                  ),
                if (role == "Admin" || role == "SuperAdmin")
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ApiService().deleteUtilisateur(currentUser.id);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRelationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          title: Text("Relations"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: relationsCount,
              itemBuilder: (context, index) {
                bool isUser1 = relations![index].idUtilisateur1.id == userId;
                Utilisateur otherUser = isUser1 ? relations![index].idUtilisateur2 : relations![index].idUtilisateur1;

                return ListTile(
                  title: Text('${otherUser.nom} ${otherUser.prenom}'),
                  subtitle: Text('Type: ${relations![index].idTypeRelation.intitule}'),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showStatusDialog(BuildContext context, int userId, String currentStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('L\'état actuel est : $currentStatus'),
          content: Text('Voulez-vous changer l\'état ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Bloquer'),
              onPressed: () async {
                await ApiService().updateUserStatus(userId, 'bloque');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Débloquer'),
              onPressed: () async {
                await ApiService().updateUserStatus(userId, 'normal');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
