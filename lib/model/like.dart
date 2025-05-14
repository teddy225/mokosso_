class Like {
  final int user_id;
  final int likeable_id;
  final int likeable_type;
  final String created_at;
  final String updated_at;
  final String id;

  Like({
    required this.user_id,
    required this.likeable_id,
    required this.likeable_type,
    required this.created_at,
    required this.updated_at,
    required this.id,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      user_id: json['user_id'],
      likeable_id: json['likeeable_id'],
      likeable_type: json['likeable_type'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'likeable_id': likeable_id,
      'likeable_type': likeable_type,
      'created_at': created_at,
      'updated_at': updated_at,
      'id': id,
    };
  }
}
