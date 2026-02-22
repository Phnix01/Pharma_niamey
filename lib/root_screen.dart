import 'package:flutter/material.dart';
import 'package:pharma_niamey/app_theme.dart';
import 'package:pharma_niamey/home_page.dart';
import 'package:pharma_niamey/screens/onboarding_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool? firstConnect;
  @override
  void initState() {
    super.initState();
    _loadingConnect();
  }

  Future<void> _loadingConnect() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstConnect = prefs.getBool('firstconnect') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (firstConnect == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
    }

    return firstConnect == false ? const OnboardingScreen() : const HomePage();
  }
}
