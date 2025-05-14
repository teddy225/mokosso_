import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../api/produit/provider_produit.dart';
import '../notifaction/notifaction.dart';
import 'screen_element.dart/produit_detaile.dart';

class ProduitScreen extends ConsumerWidget {
  const ProduitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listProduit = ref.watch(recuperationImage);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  //SizedBox(height: size.height * 0.04),
                  SafeArea(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'Article qui peuvent vous interresser',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Image.asset('asset/icon/icon.png',
                            width: 50, height: 50),
                        IconButton(
                          onPressed: () {
                            NotificationViewModele.showNotificationLocale(1,
                                titre: "MAKOSSO",
                                corps: "Nouvelle prière de Makosso");
                          },
                          icon: Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  )),
                  SizedBox(height: size.height * 0.02),
                  const PubContainer(),
                  SizedBox(height: size.height * 0.015),
                  const RowCategorie(),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
            listProduit.when(
              data: (produit) {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 3 : 2,
                      crossAxisSpacing: size.width * 0.02,
                      mainAxisSpacing: size.height * 0.02,
                      childAspectRatio: Platform.isAndroid ? 0.8 : 0.9,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (ctxs, index) {
                        final produitindex = produit[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProduitDetaile(produit: produitindex),
                              ),
                            );
                          },
                          child: ProduitContainer(
                            index: index,
                            key: ValueKey(produit[index].id),
                            image:
                                "https://adminmakossoapp.com/${produitindex.image}",
                            title: produitindex.name,
                            price: produitindex.price,
                          ),
                        );
                      },
                      childCount: produit.length,
                    ),
                  ),
                );
              },
              error: (error, stackTrace) => const SliverToBoxAdapter(
                child: Center(child: Text('Une erreur est survenue')),
              ),
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        );
      },
    );
  }
}

class RowCategorie extends StatelessWidget {
  const RowCategorie({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tous les produits',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ProduitContainer extends ConsumerStatefulWidget {
  final int index;
  final String image;
  final String title;
  final double price;
  const ProduitContainer(
      {required this.image,
      required this.title,
      required this.price,
      required this.index,
      super.key});

  @override
  _ProduitContainerState createState() => _ProduitContainerState();
}

class _ProduitContainerState extends ConsumerState<ProduitContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Adaptation dynamique

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 211, 255, 222),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      //margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                width: MediaQuery.sizeOf(context).width, // Adapté à l'écran
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.005,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                      ),
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.005,
                  horizontal: size.width * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.price.toStringAsFixed(0)} Fcfa",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 95, 95, 95),
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.042,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: const Color.fromARGB(255, 251, 45, 45),
                          size: size.width * 0.06,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PubContainer extends StatefulWidget {
  const PubContainer({super.key});

  @override
  State<PubContainer> createState() => _PubContainerState();
}

class _PubContainerState extends State<PubContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.8, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Adaptation dynamique

    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
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
                      'Nouveauté pour vous actuellement',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    Container(
                      height: size.height * 0.045,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Bienvenue',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                    height: 1000,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
