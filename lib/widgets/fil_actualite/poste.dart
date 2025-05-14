import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class Poste extends StatelessWidget {
  const Poste({required this.imageUrl, super.key});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: const Color.fromARGB(255, 182, 182, 182),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: CachedNetworkImage(
        imageUrl: 'https://adminmakossoapp.com/$imageUrl',
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: const Color.fromARGB(255, 148, 148, 148),
          child: Container(
            width: double.infinity,
            height: 200, // Vous pouvez ajuster la hauteur si nécessaire
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
