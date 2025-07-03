import 'package:flutter/material.dart';
import 'package:pharma_niamey/home_page.dart';
import 'package:pharma_niamey/screens/onboarding_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() async {
    final prefs = await SharedPreferences.getInstance();
    firstConnect = prefs.getBool('firstconnect')!;
  }

  late bool firstConnect;

  @override
  Widget build(BuildContext context) {
    return firstConnect ? OnboardingScreen() : HomePage();
  }
}
