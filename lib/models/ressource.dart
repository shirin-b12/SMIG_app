import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smig_app/models/categorie.dart';
import 'package:smig_app/models/tag.dart';
import 'package:smig_app/models/type.dart';
import 'package:smig_app/models/utilisateur.dart';

class Ressource {
  final int id;
  final String titre;
  final String description;
  final Image? image;
  final int vue;
  final String date_de_creation;
  final int visibilite;
  final Utilisateur createur;
  final Categorie category;
  final Type type;

  Ressource(
      {required this.id,
      required this.titre,
      required this.description,
      required this.image,
      required this.vue,
      required this.date_de_creation,
      required this.visibilite,
      required this.createur,
      required this.category,
      required this.type});

  factory Ressource.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.parse(json['date_de_creation']);
    String formattedDate = DateFormat("dd/MM/yyyy HH:mm:ss").format(dateTime);

    return Ressource(
        id: json['id_ressource'],
        createur:
            Utilisateur.fromJson(json['createur'] as Map<String, dynamic>),
        titre: json['titre'],
        description: json['description'],
        image: json['image'],
        vue: json['vue'],
        date_de_creation: formattedDate,
        visibilite: json['visibilite'],
        category: json['categorie'] != null
            ? Categorie.fromJson(json['categorie'] as Map<String, dynamic>)
            : Categorie(id: 0, nom: "Aucune catégorie"),
        type: json['type'] != null
            ? Type.fromJson(json['type'] as Map<String, dynamic>)
            : Type(id: 0, nom: "Aucun type"));
  }

  String getDateWithoutSeconds() {
    String i = "";

    for (int p = 0; p <= (date_de_creation.length - 4); p++) {
      i += date_de_creation[p];
    }

    return i;
  }
}
