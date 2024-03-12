import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Ressource {

  final String titre;
  final String description;
  final Image image;
  final int vue;
  final String date_de_creation;
  final int visibilite;

  Ressource({required this.titre, required this.description, required this.image, required this.vue, required this.date_de_creation,required this.visibilite});

  factory Ressource.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.parse(json['date_de_creation']);
    String formattedDate = DateFormat("dd/MM/yyyy HH:mm:ss").format(dateTime);

    return Ressource(
      titre: json['titre'],
      description: json['description'],
      image: Image.asset(
        'assets/other/keanu-reeves-johnny-silverhand.gif',
        width: 300,
      ),
      vue: 666,
      date_de_creation: formattedDate,
      visibilite: 0,
    );
  }

  String getDateWithoutSeconds(){
    String i = "";

    for(int p = 0; p <= (date_de_creation.length - 4); p++){
      i += date_de_creation[p];
    }

    return i;
  }
}