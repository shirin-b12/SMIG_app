import 'package:smig_app/models/utilisateur.dart';

class Commentaire {
  final int id;
  final String commentaire;
  final Utilisateur? utilisateurRedacteur; // Make this nullable
  final String dateDeCreation;
  final int idRessource;

  Commentaire({
    required this.id,
    required this.commentaire,
    this.utilisateurRedacteur, // Now nullable
    required this.dateDeCreation,
    required this.idRessource,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      id: json['id_commentaire'] as int,
      commentaire: json['commentaire'] as String,
      utilisateurRedacteur: json['createur'] == null ? null : Utilisateur.fromJson(json['createur'] as Map<String, dynamic>),
      dateDeCreation: json['date_de_creation'] as String,
      idRessource: json['id_ressource'] as int,
    );
  }
}
