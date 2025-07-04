import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:pharma_niamey/home_page.dart";
import "package:pharma_niamey/root_screen.dart";
import "package:pharma_niamey/screens/onboarding_screens.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RootScreen());
  }
}
