class Role {
  final int id;
  final String nom;

  Role({
    required this.id,
    required this.nom,
  });

  // Méthode pour convertir un objet Role en JSON
  Map<String, dynamic> toJson() {
    return {
      'id_role': id,
      'nom_role': nom,
    };
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id_role'],
      nom: json['nom_role'],
    );
  }
}