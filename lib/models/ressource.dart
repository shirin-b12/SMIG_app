import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Ressource {

  final int id;
  final String titre;
  final String description;
  final Image image;
  final int vue;
  final String date_de_creation;
  final int visibilite;

  Ressource({required this.id, required this.titre, required this.description, required this.image, required this.vue, required this.date_de_creation,required this.visibilite});

  factory Ressource.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.parse(json['date_de_creation']);
    String formattedDate = DateFormat("dd/MM/yyyy HH:mm:ss").format(dateTime);

    return Ressource(
      id: json['id_ressource'],
      titre: json['titre'],
      description: json['description'],
      image: Image.network(
        'https://cdn.discordapp.com/attachments/1158675146912038953/1212416670493052928/xythf1yzyc471.png?ex=65f1c203&is=65df4d03&hm=71b1dad53a2c5f46db92f20fa6cb449db6ddff9e93591aff50c2d696d9301688&',
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