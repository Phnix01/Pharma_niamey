import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:pharma_niamey/app_theme.dart';
import 'package:pharma_niamey/home_page.dart';
import 'package:pharma_niamey/models/onboarding_model.dart';
import 'package:pharma_niamey/screens/onboarding_page.dart';
import 'package:pharma_niamey/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnBoardingModel> _page = [
    OnBoardingModel(
      imageUrl: "assets/images/slide1.png",
      titlePage: "Trouver une pharmacie de garde n'a jamais été aussi simple",
      descriptionText:
          "Consultez chaque semaine la liste des pharmacies de garde à Niamey, où que vous soyez.",
    ),
    OnBoardingModel(
      imageUrl: "assets/images/slide2_2.png",
      titlePage: "Des informations fiables et accessibles à tous",
      descriptionText:
          "Nous mettons à jour les données régulièrement pour vous garantir un accès rapide et fiable aux soins.",
    ),
    OnBoardingModel(
      imageUrl: "assets/images/slide3.png",
      titlePage: "Commencez dès maintenant",
      descriptionText:
          "Localisez, contactez et trouvez facilement une pharmacie ouverte, 24h/24, en quelques clics.",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
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

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstconnect', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentPage < _page.length - 1)
            TextButton(
              onPressed: _completeOnboarding,
              child: const Text(
                'Passer',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
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

            // Dot indicator animé
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _page.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bouton suivant / commencer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _currentPage == _page.length - 1
                  ? ZoomIn(
                      duration: const Duration(milliseconds: 600),
                      child: Button(
                        buttonText: "Commencer",
                        buttonColors: AppColors.primary,
                        callFunction: _completeOnboarding,
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(20),
                        shape: const CircleBorder(),
                      ),
                      onPressed: _nextPage,
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 28,
                      ),
                    ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
