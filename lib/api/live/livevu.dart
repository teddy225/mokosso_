import 'package:dio/dio.dart';

import '../../main.dart';

class ApiService {
  static Dio dio = Dio(BaseOptions(
    baseUrl: 'https://adminmakossoapp.com/api/v1/live/followlive',
  ));

  // Méthode pour suivre un live
  Future<Map<String, dynamic>> followLive(int liveId, String token) async {
    try {
      final storedToken = await flutterSecureStorage.read(key: 'auth_token');

      if (storedToken == null || storedToken.isEmpty) {
        throw Exception('Le token est introuvable ou invalide.');
      }

      // Ajouter le token dans les headers
      dio.options.headers['Authorization'] = 'Bearer $storedToken';
      final response = await dio.post(
        'live/follow/$liveId',
        options: Options(
          headers: {
            'Authorization':
                'Bearer $token', // Ajout du token d'authentification
          },
        ),
      );
      print(response.data);
      return response.data;
    } catch (e) {
      throw Exception('Erreur lors de la tentative de suivre ce live.');
    }
  }
}
