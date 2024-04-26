import 'package:smig_app/models/ressource.dart';
import 'package:smig_app/models/types_relation.dart';
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
        id: json['idRelation'] as int,
        idUtilisateur1: Utilisateur.fromJson(json['utilisateur1'] as Map<String, dynamic>),
        idUtilisateur2: Utilisateur.fromJson(json['utilisateur2'] as Map<String, dynamic>),
        idTypeRelation: TypesRelation.fromJson(json['typeRelation'] as Map<String, dynamic>)
    );
  }



}
