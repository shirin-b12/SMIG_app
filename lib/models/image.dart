import 'dart:convert';
import 'dart:typed_data';

class Images {
  final int id;
  final Uint8List fichier;
  final String legende;

  Images({
    required this.id,
    required this.fichier,
    required this.legende,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      id: json['id_image'],
      fichier: base64Decode(json['fichier']),
      legende: json['legende'],
    );
  }
}
