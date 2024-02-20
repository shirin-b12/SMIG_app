class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final String email;

  Utilisateur({required this.id, required this.nom, required this.prenom, required this.email});

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id_utilisateur'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
    );
  }
}
