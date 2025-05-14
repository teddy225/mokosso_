import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:retry/retry.dart';

import 'live_model.dart';

class LiveService {
  final flutterSecureStorage = const FlutterSecureStorage();

  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://adminmakossoapp.com/api/v1/live'));

  /// Récupère les publications de l'actualité. Si un cache est disponible dans SQLite, il est utilisé.
  /// Sinon, une requête API est effectuée.
  Future<List<LiveModel>> liveStreamUrlProvider({int isFeeded = 0}) async {
    try {
      final storedToken = await flutterSecureStorage.read(key: 'auth_token');

      if (storedToken == null || storedToken.isEmpty) {
        throw Exception('Le token est introuvable ou invalide.');
      }

      // Ajouter le token dans les headers
      _dio.options.headers['Authorization'] = 'Bearer $storedToken';

      // Construire l'endpoint basé sur le paramètre 'isFeeded'
      final endpoint = isFeeded == 1 ? '/feeded' : '';

      // Effectuer la requête avec une gestion des tentatives de reconnexion en cas d'échec
      final response = await retry(
        () async {
          final response = await _dio.get(endpoint);
          if (response.statusCode == 200) {
            // Récupérer les données de la réponse
            final responseData = response.data;
            print(responseData);
            // Vérifier que "live" existe et est une liste
            if (responseData != null && responseData['live'] != null) {
              // Mapper la liste "live" vers des objets TextPublication
              final liveList = (responseData['live'] as List)
                  .map((item) => LiveModel.fromJson(item))
                  .toList();

              return liveList;
            } else {
              throw Exception('Aucune donnée de flux en direct disponible.');
            }
          } else {
            // En cas d'erreur de réponse (par exemple, 404 ou 500)
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
            );
          }
        },
        retryIf: (e) => e is DioException || e is TimeoutException,
        maxAttempts: 3, // Nombre de tentatives de reconnexion
        delayFactor: const Duration(seconds: 2), // Délai entre chaque tentative
        onRetry: (e) => print('Nouvelle tentative après échec: $e'),
      ).timeout(const Duration(seconds: 30)); // Délai maximal pour la requête

      // Retourner les publications récupérées
      return response;
    } catch (e) {
      // Gestion des erreurs réseau spécifiques à Dio
      if (e is DioException) {
        if (e.response != null) {}
        throw Exception('Erreur réseau: ${e.message}');
      } else if (e is TimeoutException) {
        // Gestion des erreurs de délai
        throw Exception('Erreur de délai dépassé');
      } else {
        // Gestion des erreurs inattendues
        print('Erreur inattendue: $e');
        throw Exception('Erreur inattendue: $e');
      }
    }
  }
}
