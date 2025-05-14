import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retry/retry.dart';
import '../model/like.dart';

class LikeService {
  final Dio _dio = Dio(BaseOptions(
    followRedirects: true,
    validateStatus: (status) => status != 302,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Ajouter un like à un post
  Future<ApiResponse<Like>> ajouterLike({
    required int postId,
    required int userId,
  }) async {
    try {
      final storedToken = await _secureStorage.read(key: 'auth_token');
      if (storedToken == null || storedToken.isEmpty) {
        return ApiResponse.error("Le token est introuvable ou invalide.");
      }

      _dio.options.headers['Authorization'] = 'Bearer $storedToken';

      final data = {
        'likeable_id': postId,
        'likeable_type': 'Post',
      };

      const String apiUrl = 'https://adminmakossoapp.com/api/v1/likes';

      final response = await retry(
        () async => await _dio.post(apiUrl, data: data),
        retryIf: (e) => e is DioException || e is TimeoutException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
        onRetry: (e) => print('Nouvelle tentative après échec: $e'),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 201 && response.data['id'] != null) {
        final like = Like.fromJson(response.data);
        return ApiResponse.success(like);
      }

      final message = response.data['message'] ?? 'Erreur inconnue';

      // On accepte aussi "Like restauré" ou "Like supprimé" comme succès, sans Like à parser
      if (message == 'Like restauré.' || message == 'Like supprimé.') {
        return ApiResponse.successMessage(message);
      }

      return ApiResponse.error(message);
    } catch (e) {
      return ApiResponse.error("Erreur: ${e.toString()}");
    }
  }

  /// Obtenir le nombre de likes d'un post
  Future<ApiResponse<int>> getLikeCount(int postId) async {
    try {
      final storedToken = await _secureStorage.read(key: 'auth_token');
      if (storedToken == null || storedToken.isEmpty) {
        return ApiResponse.error("Le token est introuvable ou invalide.");
      }

      _dio.options.headers['Authorization'] = 'Bearer $storedToken';

      final String apiUrl =
          'https://adminmakossoapp.com/api/v1/post/$postId/likes';

      final response = await retry(
        () async => await _dio.get(apiUrl),
        retryIf: (e) => e is DioException || e is TimeoutException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
        onRetry: (e) => print('Nouvelle tentative après échec: $e'),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data['likes_count'] ?? 0);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Erreur inconnue');
      }
    } catch (e) {
      return ApiResponse.error("Erreur: ${e.toString()}");
    }
  }
}

/// Classe générique pour gérer les réponses API
class ApiResponse<T> {
  final T? data;
  final String? errorMessage;
  final bool success;

  ApiResponse.success(this.data)
      : success = true,
        errorMessage = null;

  ApiResponse.successMessage(String message)
      : data = null,
        success = true,
        errorMessage = message;

  ApiResponse.error(this.errorMessage)
      : success = false,
        data = null;
}
