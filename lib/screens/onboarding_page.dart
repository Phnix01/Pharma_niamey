import "package:flutter/material.dart";
import "package:animate_do/animate_do.dart";
import "package:pharma_niamey/models/onboarding_model.dart";

class OnboardingPage extends StatelessWidget {
  final OnBoardingModel page;
  const OnboardingPage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(
            child: Image.asset(
              page.imageUrl,
              width: double.infinity,
              height: _size.width * 1,
              fit: BoxFit.fitHeight,
            ),
          ),
          Text(
            page.titlePage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          FadeIn(
            child: Text(
              page.descriptionText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
