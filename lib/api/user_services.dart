import 'package:dio/dio.dart';
import '../model/user.dart';

class UserService {
  final Dio _dio = Dio();

  Future<User> getUserById(int userId) async {
    final String apiUrl = "https://adminmakossoapp.com/api/v1/users/$userId";

    try {
      final response = await _dio.get(apiUrl);
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception("Impossible de récupérer l'utilisateur.");
      }
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }
}
