import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/paiment/cinepaie.dart';
import '../../provider/auth_provider.dart';

class Donation extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _payscontroller = TextEditingController();

  final TextEditingController _telController = TextEditingController();

  Donation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentService = ref.read(paymentServiceProvider);
    final authState = ref.watch(userProfileProvider);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          final contentWidth = isWideScreen ? 600.0 : double.infinity;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: size.width * 0.03),
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.03),
                        height: size.height * 0.18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.green, Color(0xFF007A5E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Faire un don pour soutenir la vision du Général Camille Makosso vis-à-vis des veuves et des orphelins',
                                    style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Transform.translate(
                                offset: Offset(0, -size.height * 0.00),
                                child: Image.asset(
                                  'assets/images/p4.png',
                                  fit: BoxFit.contain,
                                  height: 700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "La vraie religion agréable à Dieu consiste à s’occuper des veuves et des orphelins.",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _amountController,
                        decoration:
                            const InputDecoration(labelText: 'Montant (XOF)'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Entrez un montant' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _payscontroller,
                        decoration: const InputDecoration(labelText: 'Pays'),
                        validator: (value) =>
                            value!.isEmpty ? 'Reseigner votre pays' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _telController,
                        decoration: const InputDecoration(
                            labelText: 'Numéro de téléphone'),
                        validator: (value) =>
                            value!.isEmpty ? 'Entrez votre numéro' : null,
                      ),
                      const SizedBox(height: 24),
                      authState.when(
                        data: (user) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFF007A5E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await paymentService.createPayment(
                                    montant: _amountController.text,
                                    pays: _payscontroller.text,
                                    tel: user.phone,
                                    description: 'donatipn',
                                    name: user.username,
                                    email: user.email,
                                    iDuser: user.id.toString());
                              }
                            },
                            child: Text('Faire un don'),
                          );
                        },
                        error: (error, stackTrace) => const SizedBox(),
                        loading: () => const CircularProgressIndicator(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
