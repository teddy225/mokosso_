import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/live/provider_live.dart';
import '../../api/live/provider_vu.dart';
import '../../main.dart';

class YouTubeLivePlayer extends ConsumerStatefulWidget {
  final int liveId; // Ajouter un champ pour l'ID du live

  const YouTubeLivePlayer(
      {super.key, required this.liveId}); // Passer l'ID du live au constructeur

  @override
  ConsumerState<YouTubeLivePlayer> createState() => _YouTubeLivePlayerState();
}

class _YouTubeLivePlayerState extends ConsumerState<YouTubeLivePlayer> {
  YoutubePlayerController? _controller;
  bool _hasError = false;

  String? extractYoutubeId(String url) {
    final regex = RegExp(r'(?:v=|\/)([0-9A-Za-z_-]{11}).*');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  @override
  void initState() {
    super.initState();
    _followLive(); // Suivre le live dès que la page est chargée
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _listenToPlayer() {
    _controller?.addListener(() {
      if (!_controller!.value.isReady && _controller!.value.hasError) {
        setState(() {
          _hasError = true;
        });
      }
    });
  }

  // Méthode pour suivre le live
  void _followLive() async {
    final storedToken = await flutterSecureStorage.read(key: 'auth_token');
    final token = storedToken.toString(); // Récupérer le token de l'utilisateur

    // Suivre le live via le provider
    await ref
        .read(followLiveProvider.notifier)
        .followLive(widget.liveId, token); // Passer l'ID du live dynamique
  }

  @override
  Widget build(BuildContext context) {
    final liveStreamUrlAsyncValue = ref
        .watch(liveStreamUrlProvider(widget.liveId)); // Utiliser l'ID dynamique

    return Scaffold(
      appBar: AppBar(title: const Text("Regarder le Live Stream")),
      body: liveStreamUrlAsyncValue.when(
        data: (live) {
          final liveStreamUrl = live.isNotEmpty ? live[0].lien : null;
          if (liveStreamUrl == null) {
            return const Center(child: Text('Pas de direct disponible.'));
          }

          final videoId = extractYoutubeId(liveStreamUrl);
          if (videoId == null) {
            return const Center(child: Text('Live plus disponible.'));
          }

          _controller = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              isLive: true,
            ),
          );

          _listenToPlayer();

          if (_hasError) {
            return const Center(
              child: Text(
                'Le live n’est est terminé ou indisponible.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YoutubePlayer(controller: _controller!),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Titre: ${live[0].titre}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Description: ${live[0].description}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        '',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Chargement"),
              CircularProgressIndicator(),
            ],
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Pas de direct disponible.',
                  style: TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(liveStreamUrlProvider(
                      widget.liveId)); // Utiliser l'ID du live
                },
                child: const Text('Recharger'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.invalidate(
              liveStreamUrlProvider(widget.liveId)); // Utiliser l'ID du live
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
