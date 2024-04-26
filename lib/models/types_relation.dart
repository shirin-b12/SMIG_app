class TypesRelation {
  final int id;
  final String intitule;

  TypesRelation({
    required this.id,
    required this.intitule,
  });

  factory TypesRelation.fromJson(Map<String, dynamic> json) {
    return TypesRelation(
      id: json['idTypeRelation'],
      intitule: json['intitule'],
    );
  }
}
