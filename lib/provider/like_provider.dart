import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/like_service.dart';
import '../model/like.dart';

final likeServiceProvider = Provider((ref) => LikeService());

/// ✅ StateNotifier pour suivre le nombre de likes en direct
class LikeCountNotifier extends StateNotifier<int> {
  final LikeService _service;
  final int _postId;

  LikeCountNotifier(this._postId, this._service) : super(0) {
    _loadInitialCount();
  }

  /// Charge le nombre de likes initial depuis l'API
  Future<void> _loadInitialCount() async {
    final response = await _service.getLikeCount(_postId);
    if (response.success) {
      state = response.data ?? 0;
    }
  }

  /// Met à jour localement le nombre de likes après un like/unlike
  void updateLikeCount(bool isLiked) {
    state = isLiked ? state + 1 : state - 1;
  }
}

/// ✅ Fournisseur pour le compteur de likes (géré en direct)
final likeCountProvider =
    StateNotifierProvider.family<LikeCountNotifier, int, int>(
  (ref, postId) {
    final service = ref.watch(likeServiceProvider);
    return LikeCountNotifier(postId, service);
  },
);

/// ✅ Fournisseur pour ajouter un like et mettre à jour le compteur
final ajouterLikeProvider =
    FutureProvider.family<ApiResponse<Like>, Map<String, dynamic>>(
  (ref, likeData) async {
    final service = ref.watch(likeServiceProvider);
    final postId = likeData['post_id'];
    final userId = likeData['user_id'];

    final response = await service.ajouterLike(postId: postId, userId: userId);

    if (response.success) {
      // Mettre à jour le compteur en direct
      final notifier = ref.read(likeCountProvider(postId).notifier);
      if (response.errorMessage == "Like supprimé.") {
        notifier.updateLikeCount(false);
      } else {
        notifier.updateLikeCount(true);
      }
    } else {
      print("Erreur lors du like : ${response.errorMessage}");
    }

    return response;
  },
);
