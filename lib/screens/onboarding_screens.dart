import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:pharma_niamey/home_page.dart';
import 'package:pharma_niamey/models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnBoardingModel> _page = [
    OnBoardingModel(
      imageUrl: "assets/images/onboarding_1.png",
      titlePage: "Exprime ta beauté avec pudeur",
      descriptionText:
          "Découvre une nouvelle manière de t’habiller, avec élégance, respect et authenticité.",
    ),
    OnBoardingModel(
      imageUrl: "assets/images/onboarding_2.png",
      titlePage: "Trouve ton hijab parfait",
      descriptionText:
          "Parcourez des centaines de styles sélectionnés avec soin pour toutes les occasions.",
    ),
    OnBoardingModel(
      imageUrl: "assets/images/onboarding_3.png",
      titlePage: "Rejoins une communauté inspirante",
      descriptionText:
          "Plus qu'une boutique, une communauté de femmes fières et engagées. Bienvenue chez toi.",
    ),
    OnBoardingModel(
      imageUrl: "assets/images/onboarding_4_2.png",
      titlePage: "Livraison Rapide et Professionnelle",
      descriptionText:
          "Plus qu'une boutique, une communauté de femmes fières et engagées. Bienvenue chez toi.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _page.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: IntrinsicHeight(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/welcome_welcome.png"),
                  const SizedBox(height: 20),
                  const Text(
                    "Bienvenue",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Button(
                    buttonText: "Découvrir",
                    buttonColors: Colors.black,
                    callFunction: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(foregroundColor: Colors.transparent),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: _page.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return OnboardingPage(page: _page[index]);
                    },
                  ),
                ),

                Center(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: _currentPage == _page.length - 1
                        ? ZoomIn(
                            duration: Duration(seconds: 3),
                            child: Button(
                              buttonText: "Commencer",
                              buttonColors: Colors.black,
                              callFunction: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              },
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.all(20),
                              shape: CircleBorder(),
                            ),
                            onPressed: _nextPage,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 35,
                            ),
                          ),
                  ),
                ),
                // maintenant je vais attaquer le dot indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    _page.length,
                    (index) => Container(
                      margin: const EdgeInsets.all(4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),

                // bouton suivant/ commencer
              ],
            ),
          ),
        ),
      ],
    );
  }
}
