import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  late AnimationController _carController;
  late Animation<double> _carPositionAnimation;
  late Animation<double> _carScaleAnimation;
  late Animation<double> _carRotationAnimation;
  late Animation<double> _buttonRadiusAnimation;
  bool _showIntro = true;
  bool _isButtonClicked = false;

  @override
  void initState() {
    super.initState();

    // Animation d'entrée
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animation pour le rayon du bouton
    _buttonRadiusAnimation = Tween<double>(begin: 30.0, end: 100.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animation pour le carré
    _carController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _carPositionAnimation = Tween<double>(
      begin: -100.0, // Position initiale (hors écran à gauche)
      end: MediaQueryData.fromView(WidgetsBinding.instance.window).size.width /
              2 -
          25, // Arrête le carré au centre
    ).animate(CurvedAnimation(parent: _carController, curve: Curves.easeInOut));

    _carScaleAnimation = Tween<double>(
      begin: 1.0, // Taille initiale
      end: 3.0, // Taille finale (grossir)
    ).animate(CurvedAnimation(parent: _carController, curve: Curves.easeIn));

    _carRotationAnimation = Tween<double>(
      begin: 0.0, // Pas de rotation initiale
      end: 2 * 3.14159, // Une rotation complète
    ).animate(CurvedAnimation(parent: _carController, curve: Curves.easeInOut));

    // Lancer l'animation initiale
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _carController.dispose();
    super.dispose();
  }

  void _startTransition() {
    setState(() {
      _isButtonClicked = true;
      _showIntro = false; // Masquer l'introduction
    });

    // Lancer l'animation du carré
    _carController.forward();

    // Rediriger après l'animation
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed(
          'authScreen'); // Assurez-vous que la route 'authScreen' existe
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(197, 82, 184, 85),
              image: DecorationImage(
                image: AssetImage('assets/images/intro.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (_showIntro)
            // Texte d'introduction avec animation
            Positioned(
              top: 400,
              left: 0,
              right: 120,
              child: SlideTransition(
                position: _offsetAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Column(
                    children: [
                      Text(
                        "Bienvenue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 4.0,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Dans l'application du général ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 4.0,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_showIntro)
            Positioned(
              bottom: screenHeight * 0.07,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _offsetAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Text(
                          "Avec l'application Makosso, suivez les actualités, prières audio et bien plus.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.055,
                            color: const Color.fromARGB(179, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: const Offset(2.0, 2.0),
                                blurRadius: 4.0,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      AnimatedBuilder(
                        animation: _buttonRadiusAnimation,
                        builder: (context, child) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.2,
                                vertical: screenHeight * 0.02,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  _isButtonClicked
                                      ? _buttonRadiusAnimation.value
                                      : 30.0,
                                ),
                              ),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green,
                            ),
                            onPressed: _startTransition,
                            child: Text(
                              "Démarrer",
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!_showIntro)
            AnimatedBuilder(
              animation: _carController,
              builder: (context, child) {
                return Positioned(
                  top: screenHeight * 0.4, // Hauteur fixe
                  left: _carPositionAnimation.value, // Position horizontale
                  child: Transform.scale(
                    scale: _carScaleAnimation.value, // Échelle du carré
                    child: Transform.rotate(
                      angle: _carRotationAnimation.value, // Rotation du carré
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Image.asset('asset/icon/icon1.png'),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
