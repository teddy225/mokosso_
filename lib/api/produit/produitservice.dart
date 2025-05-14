import 'dart:async';

import 'package:dio/dio.dart';
import 'package:retry/retry.dart';

import '../../model/produit_model.dart';

class ProduitApiService {
  Dio dio = Dio();

  Future<List<Product>> recuperationProduit() async {
    try {
      final reponse = await retry(
        () async {
          final reponse =
              await dio.get('https://adminmakossoapp.com/api/v1/products');
          if (reponse.statusCode == 200) {
            List<Product> produits = (reponse.data as List).map(
              (produitJson) {
                return Product.fromJson(produitJson);
              },
            ).toList();
            print('Réponse success : ${produits.length} produits récupérés');
            return produits;
          } else {
            throw DioException(
              requestOptions: reponse.requestOptions,
              response: reponse,
              type: DioExceptionType.badResponse,
            );
          }
        },
        retryIf: (e) => e is DioException || e is TimeoutException,
      ).timeout(
        const Duration(seconds: 64),
      );
      return reponse;
    } catch (e) {
      if (e is DioException) {
        print('Erreur réseau: ${e.message}');
        if (e.response != null) {
          print(
              'Statut du serveur: ${e.response?.statusCode}, Message: ${e.response?.statusMessage}');
        }
        throw Exception('Erreur réseau: ${e.message}');
      } else if (e is TimeoutException) {
        throw Exception('Erreur de délai dépassé');
      } else {
        print('Erreur inattendue: $e');
        throw Exception('Erreur inattendue: $e');
      }
    }
  }
}
