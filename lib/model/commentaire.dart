class Comment {
  final int id; // ID du commentaire.
  final String content; // Contenu du commentaire.
  final int postId; // ID de la publication associée.
  final int userId; // Auteur du commentaire.
  final DateTime createdAt; // Date de création du commentaire.
  final DateTime updatedAt; // Date de mise à jour du commentaire.

  Comment({
    required this.id,
    required this.content,
    required this.postId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Méthode pour convertir un objet JSON en instance de Comment.
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'], // ID du commentaire.
      content: json['content'], // Contenu du commentaire.
      postId: json['post_id'], // ID de la publication.
      userId: json['user_id'], // Auteur du commentaire.
      createdAt: DateTime.parse(json['created_at']), // Date de création.
      updatedAt: DateTime.parse(json['updated_at']), // Date de mise à jour.
    );
  }

  // Méthode pour convertir une instance de Comment en JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'post_id': postId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
