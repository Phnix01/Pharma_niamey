import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pharma_niamey/app_theme.dart';
import 'package:pharma_niamey/firebase_options.dart';
import 'package:pharma_niamey/services/notification_service.dart';
import 'package:pharma_niamey/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  Object? firebaseError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await NotificationService.initialize();
  } catch (e) {
    firebaseError = e;
  }

  runApp(MyApp(firebaseError: firebaseError));
}

class MyApp extends StatelessWidget {
  final Object? firebaseError;

  const MyApp({super.key, this.firebaseError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharma Niamey',
      theme: AppTheme.lightTheme,
      home: firebaseError != null
          ? _FirebaseErrorScreen(error: firebaseError!)
          : const SplashScreen(),
    );
  }
}

class _FirebaseErrorScreen extends StatelessWidget {
  final Object error;
  const _FirebaseErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 80,
                color: AppColors.error.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 24),
              Text(
                'Erreur de connexion',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Impossible d\'initialiser les services. '
                'Vérifiez votre connexion internet et relancez l\'application.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
