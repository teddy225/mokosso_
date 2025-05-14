import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../provider/auth_provider.dart';
import '../../provider/commentaire_provider.dart';
import '../../provider/like_provider.dart';

class SectionCommentaire extends StatelessWidget {
  SectionCommentaire({
    super.key,
    required this.nombreCommentaire,
    required this.nombreLike,
    required this.idcommentaire,
  });

  final int nombreCommentaire;
  final int nombreLike;
  final int idcommentaire;

  void showCommentsModal({required BuildContext context, required int postId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, child) {
            final commentsAsyncValue =
                ref.watch(commentaireStreamProvider(postId));
            ref.invalidate(commentaireStreamProvider(postId));
            final authState = ref.watch(userProfileProvider);

            return SizedBox(
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Commentaires',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: commentsAsyncValue.when(
                      data: (comments) {
                        return ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            String? formatDate(DateTime? dateTime) {
                              if (dateTime == null) {
                                return null;
                              }
                              return DateFormat('dd MMMM yyyy')
                                  .format(dateTime);
                            }

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(Icons.person),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              authState.maybeWhen(
                                                data: (user) {
                                                  return user.id ==
                                                          comment.userId
                                                      ? 'Vous'
                                                      : 'Anonyme';
                                                },
                                                orElse: () => 'Anonyme',
                                              ),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              formatDate(comment.createdAt) ??
                                                  'Date inconnue',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          comment.content,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                          child:
                              Text("probleme de reseau reessayer plus tard")),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section "Likes & Comments"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    nombreCommentaire.toString(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      showCommentsModal(
                          context: context, postId: idcommentaire);
                    },
                    child: Text(
                      'commentaires',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () async {
                      final Uri fbUrl = Uri.parse(
                          "https://www.facebook.com/share/1Y6mDJ1QGa/?mibextid=wwXIfr");
                      final Uri webUrl = Uri.parse(
                          "https://www.facebook.com/share/1Y6mDJ1QGa/?mibextid=wwXIfr");

                      if (await canLaunchUrl(fbUrl)) {
                        await launchUrl(fbUrl,
                            mode: LaunchMode.externalApplication);
                      } else if (await canLaunchUrl(webUrl)) {
                        await launchUrl(webUrl,
                            mode: LaunchMode.externalApplication);
                      } else {
                        print(
                            "\ud83d\udeab Impossible d'ouvrir la page Facebook.");
                      }
                    },
                    child: Text(
                      'partages',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Section "Likes, Comments, Shares"
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300, blurRadius: 6, spreadRadius: 2)
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Likes section with dynamic count
              Row(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final likeCountAsync =
                          ref.watch(likeCountProvider(idcommentaire));
                      final authState = ref.watch(userProfileProvider);
                      final userId = authState.maybeWhen(
                        data: (user) => user.id,
                        orElse: () => null,
                      );
                      return InkWell(
                        onTap: () async {
                          await ref.read(ajouterLikeProvider({
                            'post_id': idcommentaire,
                            'user_id': userId,
                          }).future);
                        },
                        child: Row(
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final likeCount =
                                    ref.watch(likeCountProvider(idcommentaire));

                                return Text(
                                  likeCount.toString(),
                                  style: Theme.of(context).textTheme.labelLarge,
                                );
                              },
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.favorite,
                              size: 24,
                              color: Color.fromARGB(255, 18, 95, 21),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              // Comment section
              Row(
                children: [
                  const Icon(Icons.message, size: 22),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        isScrollControlled:
                            true, // Permet de contrôler la hauteur de la BottomSheet
                        builder: (ctx) {
                          return Consumer(
                            builder: (context, ref, child) {
                              final authState = ref.watch(userProfileProvider);
                              final TextEditingController commentController =
                                  TextEditingController();

                              return Container(
                                height: 500,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: SingleChildScrollView(
                                  // Rendre la BottomSheet défilable
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Ajouter un commentaire",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),

                                      // Champ de texte avec un design moderne
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: TextField(
                                            controller: commentController,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Écrivez un commentaire...",
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 15),

                                      authState.when(
                                        data: (user) => GestureDetector(
                                          onTap: () async {
                                            if (commentController.text
                                                .trim()
                                                .isNotEmpty) {
                                              await ref.read(
                                                  ajouterCommentaireProvider({
                                                'post_id': idcommentaire,
                                                'contenu':
                                                    commentController.text,
                                                'userId': user.id,
                                              }).future);
                                              ref.invalidate(
                                                  commentaireStreamProvider(
                                                      idcommentaire));
                                              commentController.clear();

                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "Envoyer",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                        error: (error, stackTrace) =>
                                            const SizedBox(),
                                        loading: () =>
                                            const CircularProgressIndicator(),
                                      ),

                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Text("Commenter",
                        style: Theme.of(context).textTheme.labelMedium),
                  ),
                ],
              ),
              // Share section
              Row(
                children: [
                  const Icon(Icons.share, size: 22),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () async {
                      // Ton lien ou contenu à partager
                      final String appLink =
                          'https://www.facebook.com/share/1Y6mDJ1QGa/?mibextid=wwXIfr'; // Remplace par ton lien

                      // Partager sur Facebook
                      await Share.share(
                          'Découvrez cette super application : $appLink');
                    },
                    child: Text(
                      'Partager',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
