import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'live_model.dart';
import 'live_url_api.dart';

// Instance du service pour récupérer les données
final LiveProvider = Provider((ref) => LiveService());

// FutureProvider pour la récupération des posts
final liveStreamUrlProvider =
    FutureProvider.family<List<LiveModel>, int>((ref, isFeeded) async {
  final service = ref.watch(LiveProvider);
  return await service.liveStreamUrlProvider();
});
