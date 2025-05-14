import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PropositionSujetPriere extends StatefulWidget {
  const PropositionSujetPriere({super.key});

  @override
  _PropositionSujetPriereState createState() => _PropositionSujetPriereState();
}

class _PropositionSujetPriereState extends State<PropositionSujetPriere> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _priereController = TextEditingController();
  final _numController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _priereController.dispose();
    _numController.dispose();
    super.dispose();
  }

  void _sendToWhatsApp(
      String nom, String prenom, String numero, String priere) async {
    final String message =
        "Bonjour Mon générale, j'aimerais vous proposer un sujet de prière:\n\nNom: $nom\nPrénom: $prenom\nNuméro: $numero \nDescription: $priere";
    final String encodedMessage = Uri.encodeFull(message);
    const String phoneNumber =
        "33651488715"; // Remplace avec ton numéro WhatsApp

    final Uri url =
        Uri.parse("https://wa.me/$phoneNumber?text=$encodedMessage");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Impossible d\'ouvrir WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Proposer un sujet de prière au générale",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Veuillez entrer le nom' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: _prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Veuillez entrer le prénom' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _numController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Numéro de téléphone whatsapp',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Veuillez entrer le nom' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priereController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Votre sujet de priere',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Veuillez entrer une description' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Récupérer les valeurs
                  String nom = _nomController.text;
                  String prenom = _prenomController.text;
                  String priere = _priereController.text;
                  String numerotelephone = _numController.text;

                  // Faire quelque chose avec les données (ex : sauvegarder)
                  _sendToWhatsApp(nom, prenom, numerotelephone, priere);
                  print('Nom: $nom, Prénom: $prenom, Description: $priere');

                  // Fermer la modal
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Enregistrer votre Projet",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
