import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:url_launcher/url_launcher.dart';

import '../provider/audio_provider.dart';
import '../provider/event_provider.dart';
import '../provider/publication_text.dart';
import '../provider/video_provider.dart';
import '../widgets/audioliste.dart';
import '../widgets/banner_principale.dart';
import '../widgets/evenement_liste.dart';
import '../widgets/home_chargement/audio_liste_chargement.dart';
import '../widgets/home_chargement/banner_principale_chargement.dart';
import '../widgets/home_chargement/liste_video_chargement.dart';
import '../widgets/row_home.dart';
import '../widgets/video_liste.dart';
import 'project_form.dart';
import 'proposition_priere.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller pour gérer la durée de l'animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Durée de l'animation
    );

    // Animation de défilement vertical (effet de montée)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0), // Départ depuis le bas
      end: const Offset(0, 0), // Arrivée à la position d'origine
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut, // Courbe douce pour un effet naturel
      ),
    );

    // Animation de zoom (scaling) simultanée
    _scaleAnimation = Tween<double>(
      begin: 0.8, // Début de l'échelle (plus petit)
      end: 1.0, // Fin de l'échelle (taille originale)
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Animation de fondu
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Démarrer l'animation dès que l'écran est affiché
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncBannerTexte = ref.watch(textPublicationProvider(0));
    final asyncVideo = ref.watch(videoProviderList);
    final asyncAudio = ref.watch(audioProviderList);
    final asyncEvent = ref.watch(evenetLisProvider);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back_home.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Bannière principale
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation, // Ajout d'un effet de fondu
                child: SlideTransition(
                  position: _slideAnimation, // Effet de montée
                  child: ScaleTransition(
                    scale: _scaleAnimation, // Effet de zoom
                    child: asyncBannerTexte.when(
                      data: (textpublication) {
                        return BannerPrincipale(
                            textpublication: textpublication);
                      },
                      error: (error, stackTrace) {
                        return const BannerPrincipaleChargement();
                      },
                      loading: () {
                        return const BannerPrincipaleChargement();
                      },
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              left: 16,
                              right: 16,
                              top: 16,
                            ),
                            child: const PropositionSujetPriere(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                "assets/images/priere.jpeg",
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Envoyez votre sujet de prière",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "au Général Camille Makosso",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                size: 26, color: Color.fromARGB(255, 2, 2, 2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Bannière principale
            /////////////////////////////////////////////////////////////
            SliverToBoxAdapter(
              child: asyncBannerTexte.when(
                data: (textpublication) {
                  return textpublication[0]
                              .description
                              .contains('financement') ==
                          true
                      ? FadeTransition(
                          opacity: _fadeAnimation, // Ajout d'un effet de fondu
                          child: SlideTransition(
                            position: _slideAnimation, // Effet de montée
                            child: ScaleTransition(
                              scale: _scaleAnimation, // Effet de zoom
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled:
                                            true, // Pour remonter avec le clavier
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        builder: (context) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                            left: 16,
                                            right: 16,
                                            top: 16,
                                          ),
                                          child: const ProjectForm(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        top: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            195, 119, 179, 104),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.2), // Ombre plus visible
                                            spreadRadius: 3,
                                            blurRadius:
                                                12, // Augmente le flou pour un effet plus doux
                                            offset: const Offset(0,
                                                6), // Ombre plus marquée en bas
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'assets/images/financement.jpeg',
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 153, 0), // Couleur de fond
                                      elevation:
                                          8, // Ombre portée (plus la valeur est élevée, plus l'ombre est visible)
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Bords arrondis (augmente la valeur pour plus de courbure)
                                      ),
                                      shadowColor:
                                          Colors.black, // Couleur de l'ombre
                                      // Optionnel : agrandir le bouton
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled:
                                            true, // Pour remonter avec le clavier
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        builder: (context) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                            left: 16,
                                            right: 16,
                                            top: 16,
                                          ),
                                          child: const ProjectForm(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Enregistrer votre Projet",
                                      style: TextStyle(
                                        color: Colors.white, // Couleur du texte
                                        fontWeight: FontWeight
                                            .bold, // Texte en gras (optionnel)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Text('lol bbknljflkfjhelkjefhlkzfhl');
                },
                error: (error, stackTrace) {
                  return const Text('');
                },
                loading: () {
                  return const Text('');
                },
              ),
            ),

            // Section audios récents
            SliverToBoxAdapter(
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: const RowHome(
                  titreRecent: 'Prière Prophétique du Jour 🙏🔥',
                  routeName: 'audioScreen',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: asyncAudio.when(
                        data: (audioData) => Audioliste(audioData: audioData),
                        error: (error, stackTrace) => const Text(''),
                        loading: () => const AudioListeChargement(),
                      )
                      // Changer pour l'élément réel après chargement
                      ),
                ),
              ),
            ),
            // Section vidéos récentes
            SliverToBoxAdapter(
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: RowHome(
                    titreRecent: 'Videos récentes',
                    routeName: 'videoScreen',
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: asyncVideo.when(
                      data: (videoData) => VideoListe(
                        videoData: videoData,
                      ),
                      loading: () => const ListeVideoChargement(),
                      error: (error, stackTrace) => const Center(
                          child: Text(
                        'Veuillez vous connecter a internet !',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 110, 110, 110),
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                ),
              ),
            ),
            // Section événements
            SliverToBoxAdapter(
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: RowHome(
                    titreRecent: 'Événements',
                    routeName: 'evenementScreen',
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: asyncEvent.when(
                    data: (eventData) => EvenementListe(
                        evenementData: eventData), // Passez les événements
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => const Center(
                        child: Text(
                      'Veuillez vous connecter a internet !',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 110, 110, 110),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
