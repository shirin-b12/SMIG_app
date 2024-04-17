class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final int? pic;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.pic,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id_utilisateur'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      pic: json['imageProfil'] != null ? json['imageProfil']['id_image'] : null,
    );
  }

  String getProfileImageUrl() {
    print(this.pic);
    return 'http://localhost:8081/images/${this.pic}';
  }
}
