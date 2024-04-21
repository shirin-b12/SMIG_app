class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final int? pic;
  final String etat;  // Ajout de l'état de l'utilisateur

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.pic,
    required this.etat,  // Initialisation de l'état
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id_utilisateur'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      pic: json['imageProfil'] != null ? json['imageProfil']['id_image'] : null,
      etat: json['etat_utilisateur'],  // Gestion de l'état
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_utilisateur': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'imageProfil': pic,
      'etat_utilisateur': etat,
    };
  }

  String getProfileImageUrl() {
    print(this.pic);
    return 'http://localhost:8081/images/${this.pic}';
  }
}
