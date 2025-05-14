import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../provider/internet_service_provider.dart';
import '../article_screen.dart';
import '../screen_element.dart/donation.dart';
import '../screen_element.dart/live_screen.dart';
import 'tabbar.dart';

class BottomNavbar extends ConsumerStatefulWidget {
  const BottomNavbar({super.key});

  @override
  BottomNavbarState createState() => BottomNavbarState();
}

class BottomNavbarState extends ConsumerState<BottomNavbar> {
  // L'index est maintenant géré via Riverpod
  // Exemple d'un provider pour l'index de la navigation
  final _indexProvider = StateProvider<int>((ref) => 0);

  void showConnectionErrorDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: "'Pas de connexion internet',",
      desc: "Vérifiez votre connexion internet et réessayer",
      btnCancelOnPress: () {
        ref.invalidate(connectivityStreamProvider);
      },
      btnOkOnPress: () {},
    ).show();
  }

  List<Widget> list = [
    const Tabbarscreen(),
    const ProduitScreen(),
    Donation(),
    const YouTubeLivePlayer(
      liveId: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ref.watch(getNotification);

    final index = ref.watch(
        _indexProvider); // Utilisation de `watch` pour écouter l'état du provider
    final etatConnexion = ref.watch(connectivityStreamProvider);
    ref.listen(connectivityStreamProvider, (prevu, next) {
      if (next.value == false) {
        showConnectionErrorDialog(context);
      }
    });
    return Scaffold(
      body: etatConnexion.when(
        data: (isconnected) {
          return isconnected
              ? list[index]
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
        error: (error, stackTrace) {
          return SizedBox(
            height: screenHeight,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 46, 100, 48),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Icon(
                      Icons.close,
                      size: 50,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Une erreur s'est  produite ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    " Veillez verifier votre connection internet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 46, 100, 48),
                        padding: const EdgeInsets.only(
                          left: 40,
                          right: 40,
                          top: 10,
                          bottom: 10,
                        )),
                    onPressed: () {
                      ref.invalidate(connectivityStreamProvider);
                    },
                    child: const Text('Réessayer'),
                  )
                ],
              ),
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.035,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.03,
            ),
            selectedItemColor: const Color.fromARGB(255, 46, 100, 48),
            unselectedItemColor: Colors.grey[400],
            currentIndex: index,
            onTap: (value) {
              // Mise à jour de l'état via le provider
              ref.read(_indexProvider.notifier).state = value;
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 24),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined, size: 24),
                label: 'Produits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message, size: 24),
                label: 'Faire un DON',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.live_tv_sharp, size: 24),
                label: 'Live',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
