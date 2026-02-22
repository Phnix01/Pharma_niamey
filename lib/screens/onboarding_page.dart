import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:pharma_niamey/app_theme.dart';
import 'package:pharma_niamey/models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnBoardingModel page;
  const OnboardingPage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(
            child: Image.asset(
              page.imageUrl,
              width: double.infinity,
              height: size.width * 0.75,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            page.titlePage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          FadeIn(
            child: Text(
              page.descriptionText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
