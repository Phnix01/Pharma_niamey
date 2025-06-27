import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:pharma_niamey/home_page.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}
