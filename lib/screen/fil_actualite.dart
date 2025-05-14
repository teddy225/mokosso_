import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/commentaire_provider.dart';
import '../provider/fil_actualite_provider.dart';
import '../widgets/fil_actualite/description.dart';
import '../widgets/fil_actualite/poste.dart';
import '../widgets/fil_actualite/posteur.dart';
import '../widgets/fil_actualite/section_commentaire.dart';
import '../widgets/fil_actualite_chargement/description.dart';
import '../widgets/fil_actualite_chargement/poste_shimmer.dart';
import '../widgets/fil_actualite_chargement/posteur_shimmer.dart';
import '../widgets/fil_actualite_chargement/section_commentaire_shimmer.dart';

class FilActualiteScreen extends ConsumerWidget {
  const FilActualiteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFilActualite = ref.watch(filActualiteStreamProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(filActualiteStreamProvider);
        ref.invalidate(commentaireCountProvider);
      },
      child: asyncFilActualite.when(
        data: (filactualites) => CustomScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Permet de scroller même si la liste est vide
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final filactualite = filactualites[index];
                  return Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 235, 235, 235),
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.03),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Posteur(
                                dateposte: filactualite.created_at as DateTime),
                            Description(description: filactualite.description),
                            Poste(imageUrl: filactualite.url),
                            SectionCommentaire(
                              nombreCommentaire: ref
                                  .watch(
                                      commentaireCountProvider(filactualite.id))
                                  .maybeWhen(
                                    data: (count) => count,
                                    orElse: () => 0,
                                  ),
                              nombreLike: 0,
                              idcommentaire: filactualite.id,
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                childCount: filactualites.length,
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.close, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "Une erreur s'est produite probleme de connexion veuille réessayer plus tard",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                onPressed: () {
                  ref.invalidate(filActualiteStreamProvider);
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        loading: () => CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const Column(
                  children: [
                    SizedBox(height: 20),
                    PosteurShimmer(),
                    DescriptionShimmer(),
                    PosteShimmer(),
                    SectionCommentaireShimmer(),
                    SizedBox(height: 5),
                  ],
                ),
                childCount: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
