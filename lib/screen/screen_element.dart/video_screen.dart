import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import '../../provider/video_provider.dart';
import 'video_player_screen.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    final videoList = ref.watch(videoProviderList).value;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text("actualités vidéos du général"),
      ),
      body: Container(
        //image de fond
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back_home.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: screenHeight * 0.004,
                horizontal: screenWidth * 0.0,
              ),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green,
                image: const DecorationImage(
                  image: AssetImage('assets/images/video.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 87, 87, 87).withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            // Section vidéo principale

            const SizedBox(height: 10),
            // Section liste des vidéos

            Expanded(
              child: videoList == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: videoList.length,
                      itemBuilder: (context, index) {
                        final video = videoList[index];

                        String? formatDate(DateTime? dateTime) {
                          if (dateTime == null) {
                            return null;
                          }
                          return DateFormat('dd MMM yyyy').format(dateTime);
                        }

                        String? formatHeure(DateTime? dateTime) {
                          if (dateTime == null) {
                            return null;
                          }
                          return DateFormat('hh:mm').format(dateTime);
                        }

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  currentIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: const Color.fromARGB(255, 202, 202, 202),
                              ),
                            ),
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Afficher la vignette si elle est dans le cache
                                SizedBox(
                                  child: Center(
                                      child: Container(
                                    height: 130,
                                    width: 190,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: const DecorationImage(
                                        image:
                                            AssetImage('assets/images/p8.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, right: 9, left: 9),
                                          child: Text(
                                            video.description,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Publié le ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 88, 88, 88),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5, left: 10),
                                          child: Text(
                                            "${formatDate(video.created_at)}  à ${formatHeure(video.created_at)}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 119, 119, 119),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
