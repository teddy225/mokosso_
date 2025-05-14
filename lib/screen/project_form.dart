import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectForm extends StatefulWidget {
  const ProjectForm({super.key});

  @override
  _ProjectFormState createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _numController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _descriptionController.dispose();
    _numController.dispose();
    super.dispose();
  }

  void _sendToWhatsApp(
      String nom, String prenom, String numero, String descrption) async {
    final String message =
        "Bonjour Mon générale,j'aimerais vous proposer mon projet :\n\nNom: $nom\nPrénom: $prenom\nNuméro: $numero \nDescription: $descrption";
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
              "Enregistrer votre Projet",
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
              controller: _descriptionController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Description de votre projet',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Veuillez entrer une description' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 12, 102, 12),
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
                  String description = _descriptionController.text;
                  String numerotelephone = _numController.text;

                  // Faire quelque chose avec les données (ex : sauvegarder)
                  _sendToWhatsApp(nom, prenom, numerotelephone, description);

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
