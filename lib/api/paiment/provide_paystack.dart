import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider pour Dio
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api-checkout.cinetpay.com/v2',
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  // Intercepteur pour voir les logs
  dio.interceptors.add(LogInterceptor(
    responseBody: true,
    requestBody: true,
  ));

  return dio;
});
