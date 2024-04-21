import 'package:flutter/material.dart';
import '../models/utilisateur.dart';
import '../../services/auth_service.dart';

class UtilisateurCard extends StatefulWidget {
  final Utilisateur utilisateur;

  UtilisateurCard({required this.utilisateur});

  @override
  _UtilisateurCardState createState() => _UtilisateurCardState();
}

class _UtilisateurCardState extends State<UtilisateurCard> {
  Future<String> fetchUserRole() async {
    String? role = await AuthService().getCurrentUserRole();
    return role ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchUserRole(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData && snapshot.data == 'Modérateur') {
          return Card(
            child: ListTile(
              title: Text(
                  widget.utilisateur.nom + " " + widget.utilisateur.prenom),
              subtitle: Text(widget.utilisateur.email),
              trailing: IconButton(
                icon: Icon(widget.utilisateur.status == Status.bloque
                    ? Icons.check
                    : Icons.block),
                onPressed: () {
                  setState(() {
                    widget.utilisateur.status =
                        widget.utilisateur.status == Status.bloque
                            ? Status.normal
                            : Status.bloque;
                    // Code to update utilisateur status in the backend
                  });
                },
              ),
            ),
          );
        } else {
          return Card(
            child: ListTile(
              title: Text(
                  widget.utilisateur.nom + " " + widget.utilisateur.prenom),
              subtitle: Text(widget.utilisateur.email),
            ),
          );
        }
      },
    );
  }
}
