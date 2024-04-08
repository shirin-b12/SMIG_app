class Tag {
  final int id;
  final String nom;

  Tag({
    required this.id,
    required this.nom,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id_tag'],
      nom: json['nom_tag'],
    );
  }
}
