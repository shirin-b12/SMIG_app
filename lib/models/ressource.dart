import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smig_app/models/categorie.dart';
import 'package:smig_app/models/image.dart';
import 'package:smig_app/models/tag.dart';
import 'package:smig_app/models/type.dart';
import 'package:smig_app/models/utilisateur.dart';
import 'dart:typed_data';

class Ressource {
  final int id;
  final String titre;
  final String description;
  final int? image;
  final String date_de_creation;
  final int visibilite;
  final Utilisateur createur;
  final String category;
  final String type;
  final String tags;

  Ressource(
      {required this.id,
      required this.titre,
      required this.description,
      required this.image,
      required this.date_de_creation,
      required this.visibilite,
      required this.createur,
      required this.category,
      required this.type,
      required this.tags});

  factory Ressource.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.parse(json['dateDeCreation']);
    String formattedDate = DateFormat("dd/MM/yyyy HH:mm:ss").format(dateTime);

    return Ressource(
        id: json['id'],
        createur:
            Utilisateur.fromJson(json['createur'] as Map<String, dynamic>),
        titre: json['titre'],
        description: json['description'],
        image: json['image'] != null ? json['image']['id_image'] : null,
        date_de_creation: formattedDate,
        visibilite: json['visibilite'],
        category: json['nomCategorie'],
        type: json['nomType'],
        tags: json['nomTag'],
        );
  }

  String getDateWithoutSeconds() {
    String i = "";
    for (int p = 0; p <= (date_de_creation.length - 4); p++) {
      i += date_de_creation[p];
    }
    return i;
  }

  String getRessourceImageUrl() {
    print(this.image);
    return 'http://localhost:8081/images/${this.image}';
  }

}
