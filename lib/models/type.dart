class Type {
  final int id;
  final String nom;

  Type({
    required this.id,
    required this.nom,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      id: json['id_type'],
      nom: json['nom_type'],
    );
  }
}
