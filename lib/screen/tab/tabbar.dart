import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/auth_provider.dart';
import '../fil_actualite.dart';
import '../home_screen.dart';

class Tabbarscreen extends ConsumerWidget {
  // Change to ConsumerWidget to use Riverpod context
  const Tabbarscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userProfileProvider);

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 46, 100, 48),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Row(
              children: [
                Container(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Bienvenue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          authState.when(
                            data: (user) {
                              return Text(
                                user.username.toUpperCase(),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 223, 223, 223),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                            error: (error, stackTrace) {
                              print('error');
                              return const Text(
                                "Très chère...",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 223, 223, 223),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                            loading: () {
                              return const Text("...");
                            },
                          )
                        ],
                      ),
                      const Text(
                        'Que cette journée vous soit bénie',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Accueil',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Fil d\'actualité',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () async {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.info,
                  animType: AnimType.rightSlide,
                  title: "vous semblez vouloit vous déconnecter",
                  desc: " voulez-vous vraiment vous déconnecter?",
                  btnCancelOnPress: () async {},
                  btnOkOnPress: () async {
                    await ref.read(authStateProvider.notifier).logout();
                    // Rediriger vers la page de login
                    Navigator.pushReplacementNamed(context, 'authScreen');
                  },
                ).show();
              },
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: const TabBarView(
          children: <Widget>[HomeScreen(), FilActualiteScreen()],
        ),
      ),
    );
  }
}
