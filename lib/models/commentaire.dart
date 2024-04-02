import 'package:smig_app/models/ressource.dart';
import 'package:smig_app/models/utilisateur.dart';

class Commentaire {
  final int id;
  final String commentaire;
  final Utilisateur idUtilisateurRedacteur;
  final String dateDeCreation;
  final Ressource idRessource;

  Commentaire({
    required this.id,
    required this.commentaire,
    required this.idUtilisateurRedacteur,
    required this.dateDeCreation,
    required this.idRessource
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      id: json['id_commentaire'] as int,
      commentaire: json['commentaire'] as String,
      idUtilisateurRedacteur: Utilisateur.fromJson(json['id_utilisateur_redacteur'] as Map<String, dynamic>),
      dateDeCreation: json['date_de_creation'] as String,
      idRessource: Ressource.fromJson(json['id_ressource'] as Map<String, dynamic>)
    );
  }



}
