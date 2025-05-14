import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'livevu.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

class FollowLiveState {
  final bool isFollowing;
  final String? message;
  final int? spectateurs;

  FollowLiveState({
    required this.isFollowing,
    this.message,
    this.spectateurs,
  });

  FollowLiveState copyWith({
    bool? isFollowing,
    String? message,
    int? spectateurs,
  }) {
    return FollowLiveState(
      isFollowing: isFollowing ?? this.isFollowing,
      message: message ?? this.message,
      spectateurs: spectateurs ?? this.spectateurs,
    );
  }
}

class FollowLiveNotifier extends StateNotifier<FollowLiveState> {
  final ApiService apiService;

  FollowLiveNotifier(this.apiService)
      : super(FollowLiveState(isFollowing: false));

  Future<void> followLive(int liveId, String token) async {
    try {
      final result = await apiService.followLive(liveId, token);
      state = state.copyWith(
        isFollowing: true,
        message: result['message'],
        spectateurs: result['spectateurs'],
      );
    } catch (e) {
      state = state.copyWith(
        isFollowing: false,
        message: 'Une erreur s\'est produite lors du suivi.',
      );
    }
  }
}

final followLiveProvider =
    StateNotifierProvider<FollowLiveNotifier, FollowLiveState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return FollowLiveNotifier(apiService);
});
