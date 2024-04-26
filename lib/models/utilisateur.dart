class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final int? pic;
  late final String etat;
  final String? role;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.pic,
    required this.etat,
    required this.role
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id_utilisateur'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      pic: json['image'] != null ? json['image']['id_image'] : null,
      etat: json['etat_utilisateur'],
      role : json['role'] != null ? json['role']['nom_role'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_utilisateur': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'image': pic,
      'etat_utilisateur': etat,
      'role': role
    };
  }

  String getProfileImageUrl() {
    return 'http://localhost:8081/images/${this.pic}';
  }

  void updateStatus(String newStatus) {
    this.etat = newStatus;
  }

  String? getRole(){
    return role;
  }
}
