import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimationProviderNotider extends StateNotifier<List<bool>> {
  AnimationProviderNotider() : super(List.generate(10, (_) => false));

  //methode pour declencher l'animation pour un element
  void triggerAnimation(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) true else state[i],
    ];
  }
}

// Le provider pour gérer l'état des animations
final animationProvider =
    StateNotifierProvider<AnimationProviderNotider, List<bool>>((ref) {
  return AnimationProviderNotider();
});
