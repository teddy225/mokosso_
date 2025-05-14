import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/commentaire_service.dart';
import '../model/commentaire.dart'; // Importer le modèle des commentaires

// Instance du service pour récupérer les commentaires
final commentaireServiceProvider = Provider((ref) => CommentService());

// Fournisseur pour récupérer les commentaires d'une publication
final commentaireStreamProvider =
    FutureProvider.family<List<Comment>, int>((ref, postId) async {
  final service = ref.watch(commentaireServiceProvider);
  return await service.recupererCommentaires(postId: postId);
});

final commentaireCountProvider =
    FutureProvider.family<int, int>((ref, postId) async {
  final service = ref.watch(commentaireServiceProvider);
  final commentaires = await service.recupererCommentaires(postId: postId);
  return commentaires.length; // Retourne seulement le nombre de commentaires
});
// Fournisseur pour ajouter un commentaire à une publication
final ajouterCommentaireProvider =
    FutureProvider.family<Comment, Map<String, dynamic>>(
        (ref, commentaireData) async {
  final service = ref.watch(commentaireServiceProvider);
  final postId = commentaireData['post_id'];
  final contenu = commentaireData['contenu'];
  final userId = commentaireData['userId'];

  // Utiliser la méthode d'ajout de commentaire
  return await service.ajouterCommentaire(
      postId: postId, contenu: contenu, userId: userId);
});
