import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retry/retry.dart';
import '../model/commentaire.dart';

class CommentService {
  final flutterSecureStorage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  Future<List<Comment>> recupererCommentaires({required int postId}) async {
    try {
      final storedToken = await flutterSecureStorage.read(key: 'auth_token');
      if (storedToken == null || storedToken.isEmpty) {
        throw Exception('Le token est introuvable ou invalide.');
      }
      _dio.options.headers['Authorization'] = 'Bearer $storedToken';

      final String apiUrl =
          'https://adminmakossoapp.com/api/v1/comments/post/$postId';

      final response = await retry(
        () async {
          final response = await _dio.get(apiUrl);
          if (response.statusCode == 200 &&
              response.data is Map<String, dynamic>) {
            final responseData = response.data;
            if (responseData.containsKey('data') &&
                responseData['data'] is List) {
              return (responseData['data'] as List)
                  .map((json) => Comment.fromJson(json))
                  .toList();
            } else {
              throw Exception('Format de réponse invalide: ${response.data}');
            }
          } else {
            throw DioException(
                requestOptions: response.requestOptions, response: response);
          }
        },
        retryIf: (e) => e is DioException || e is TimeoutException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      print('Erreur lors de la récupération des commentaires: $e');
      throw Exception('Impossible de récupérer les commentaires. $e');
    }
  }

  Future<Comment> ajouterCommentaire({
    required int postId,
    required String contenu,
    required int userId,
  }) async {
    try {
      final storedToken = await flutterSecureStorage.read(key: 'auth_token');

      if (storedToken == null || storedToken.isEmpty) {
        throw Exception('Le token est introuvable ou invalide.');
      }

      _dio.options.headers['Authorization'] = 'Bearer $storedToken';

      final data = {
        'post_id': postId,
        'content': contenu,
        'user_id': userId,
      };

      const String apiUrl = 'https://adminmakossoapp.com/api/v1/comments';

      final response = await retry(
        () async {
          final response = await _dio.post(apiUrl, data: data);

          if (response.statusCode == 201) {

            if (response.data is Map<String, dynamic>) {
              return Comment.fromJson(response.data);
            } else {
              throw Exception('Réponse inattendue: Format incorrect');
            }
          } else {
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
            );
          }
        },
        retryIf: (e) => e is DioException || e is TimeoutException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
        onRetry: (e) => print('Nouvelle tentative après échec: $e'),
      ).timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {

        }
        throw Exception('Erreur réseau: ${e.message}');
      } else {
        throw Exception('Erreur inattendue: $e');
      }
    }
  }
}
