import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pharma_niamey/root_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RootScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo (à remplacer par le bon asset)
            Image.asset(
              'assets/images/logo_2_pharma_niamey.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              "Pharma Niamey",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF03A6A1),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Powered by XNova Systems",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
