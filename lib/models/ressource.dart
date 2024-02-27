import 'package:intl/intl.dart';

class Ressource {

  final String titre;
  final String description;
  final String date_de_creation;

  Ressource({required this.titre, required this.description, required this.date_de_creation});

  factory Ressource.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.parse(json['date_de_creation']);
    String formattedDate = DateFormat("dd/MM/yyyy HH:mm:ss").format(dateTime);

    return Ressource(
      titre: json['titre'],
      description: json['description'],
      date_de_creation: formattedDate,
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