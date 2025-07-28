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
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RootScreen()),
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF03A6A1),
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
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "by Omar Farouk",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const Text(
              "Powered by XNOVA Systems",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),

            const SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
