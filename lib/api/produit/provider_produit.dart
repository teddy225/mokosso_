import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'produitservice.dart';

final produitApiService = Provider((ref) {
  return ProduitApiService();
});

final recuperationImage = FutureProvider(
  (ref) {
    final imagelistProvider = ref.watch(produitApiService);
    return imagelistProvider.recuperationProduit();
  },
);
