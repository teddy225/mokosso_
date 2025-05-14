class LiveModel {
  final int id;
  final String titre;
  final String description;
  final DateTime debut;
  final int spectateurs;
  final String lien;

  LiveModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.debut,
    required this.spectateurs,
    required this.lien,
  });

  /// Convertir un JSON en un objet `LiveModel`
  factory LiveModel.fromJson(Map<String, dynamic> json) {
    return LiveModel(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      debut: DateTime.parse(json['debut']),
      spectateurs: json['spectateurs'],
      lien: json['lien'],
    );
  }

  /// Convertir un objet `LiveModel` en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'debut': debut.toIso8601String(),
      'spectateurs': spectateurs,
      'lien': lien,
    };
  }
}
