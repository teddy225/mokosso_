import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Posteur extends StatelessWidget {
  const Posteur({required this.dateposte, super.key});
  final DateTime dateposte;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              final Uri fbUrl = Uri.parse(
                  "https://www.facebook.com/share/1Y6mDJ1QGa/?mibextid=wwXIfr");
              final Uri webUrl = Uri.parse(
                  "https://www.facebook.com/share/1Y6mDJ1QGa/?mibextid=wwXIfr");

              if (await canLaunchUrl(fbUrl)) {
                await launchUrl(fbUrl, mode: LaunchMode.externalApplication);
              } else if (await canLaunchUrl(webUrl)) {
                await launchUrl(webUrl, mode: LaunchMode.externalApplication);
              } else {
                print("\ud83d\udeab Impossible d'ouvrir la page Facebook.");
              }
            },
            child: const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              backgroundImage: AssetImage('assets/images/p6.jpg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    'Générale Camille MAKOSSO',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(dateposte.toString(),
                    style: Theme.of(context).textTheme.titleSmall)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
