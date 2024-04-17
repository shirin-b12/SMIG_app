class TinyRessource {
  final int id;
  final String titre;

  TinyRessource({required this.id, required this.titre});

  factory TinyRessource.fromJson(Map<String, dynamic> json) {
    return TinyRessource(
      id: json['id_ressource'] as int,
      titre: json['titre'] as String,
    );
  }
}
