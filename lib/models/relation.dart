import 'package:smig_app/models/ressource.dart';
import 'package:smig_app/models/typesRelation.dart';
import 'package:smig_app/models/utilisateur.dart';

class Relation {
  final int id;
  final Utilisateur idUtilisateur1;
  final Utilisateur idUtilisateur2;
  final TypesRelation idTypeRelation;

  Relation({
    required this.id,
    required this.idUtilisateur1,
    required this.idUtilisateur2,
    required this.idTypeRelation
  });

  factory Relation.fromJson(Map<String, dynamic> json) {
    return Relation(
        id: json['id_relation'] as int,
        idUtilisateur1: Utilisateur.fromJson(json['id_utilisateur1'] as Map<String, dynamic>),
        idUtilisateur2: Utilisateur.fromJson(json['id_utilisateur2'] as Map<String, dynamic>),
        idTypeRelation: TypesRelation.fromJson(json['id_type_relation'] as Map<String, dynamic>)
    );
  }



}
