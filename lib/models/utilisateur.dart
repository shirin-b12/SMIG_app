enum Status { bloque, normal, signale }

class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final int? pic;
  Status status; // Removed 'final' keyword

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.pic,
    required this.status,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id_utilisateur'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      pic: json['imageProfil'] != null ? json['imageProfil']['id_image'] : null,
      status: Status.values.firstWhere(
          (e) => e.toString() == 'Status.${json['etat_utilisateur']}'),
    );
  }

  String getProfileImageUrl() {
    print(this.pic);
    return 'http://localhost:8081/images/${this.pic}';
  }

  void updateStatus(Status newStatus) {
    this.status = newStatus;
  }
}
