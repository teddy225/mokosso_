import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

import 'provide_paystack.dart';

// Provider pour le Service de Paiement
final paymentServiceProvider = Provider<PaymentService>((ref) {
  final dio = ref.read(dioProvider);
  return PaymentService(dio);
});

class PaymentService {
  final Dio _dio;
  PaymentService(this._dio);

  Future<void> createPayment(
      {required String montant,
      required String pays,
      required String tel,
      required String description,
      required String name,
      required String email,
      required String iDuser}) async {
    try {
      // Transaction ID Unique
      String transactionId = DateTime.now().millisecondsSinceEpoch.toString();

      // Données de la requête
      final data = {
        "apikey": "178122900167e2ba4fe1f4b1.16209090", // Clé API
        "site_id": "105890687", // ID du site
        "transaction_id": transactionId,
        "amount": montant, // Montant en XOF
        "currency": "XOF",
        "alternative_currency": "",
        "description": description,
        "customer_id": iDuser,
        "customer_name": name,
        "customer_surname": name,
        "customer_email": email,
        "customer_phone_number": tel,
        "customer_address": "Antananarivo",
        "customer_city": "Antananarivo",
        "customer_country": pays,
        "customer_state": "CM",
        "customer_zip_code": "065100",
        "notify_url":
            "https://webhook.site/d1dbbb89-52c7-49af-a689-b3c412df820d",
        "return_url":
            "https://webhook.site/d1dbbb89-52c7-49af-a689-b3c412df820d",
        "channels": "ALL",
        "metadata": "user1",
        "lang": "FR",
        "invoice_data": {"Donnee1": "", "Donnee2": "", "Donnee3": ""}
      };

      // Envoi de la requête POST
      final response = await _dio.post('/payment', data: data);

      if (response.data['code'] == "201") {
        var paymentUrl = response.data['data']['payment_url'];
        print("✅ URL de paiement : $paymentUrl");
        await _openPaymentUrl(paymentUrl);
      } else {
        print("⚠️ Erreur de paiement : ${response.data['message']}");
      }
    } catch (e) {
      print("❌ Erreur: $e");
    }
  }
}

Future<void> _openPaymentUrl(String url) async {
  final Uri url0 = Uri.parse(url);

  if (await canLaunchUrl(url0)) {
    await launchUrl(
      url0,
      mode: LaunchMode.externalApplication, // Ouvre dans un navigateur externe
    );
  } else {
    print("🚫 Impossible d'ouvrir l'URL : $url");
  }
}
