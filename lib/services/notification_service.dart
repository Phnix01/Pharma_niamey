import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Handler de fond (top-level, obligatoire pour FCM) ──────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase est déjà initialisé par le système quand ce handler est appelé.
  // On incrémente juste le badge localement.
  await NotificationService._incrementBadgeStatic();
}

// ── Canal Android ───────────────────────────────────────────────────────────
const AndroidNotificationChannel gardeChannel = AndroidNotificationChannel(
  'garde_channel',
  'Pharmacies de garde',
  description: 'Notifications de changement de groupe de garde chaque samedi',
  importance: Importance.high,
  playSound: true,
);

// ── Service principal ───────────────────────────────────────────────────────
class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _badgeKey = 'notification_badge_count';

  // ── Initialisation ────────────────────────────────────────────────────────

  static Future<void> initialize() async {
    // Handler de fond
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Initialisation des notifications locales (Android)
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit),
    );

    // Création du canal Android haute priorité
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(gardeChannel);

    // Demande de permission (Android 13+, iOS)
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Abonnement au topic global des gardes
    await FirebaseMessaging.instance.subscribeToTopic('garde_active');

    // Écoute des messages en premier plan
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  // ── Gestion des messages en premier plan ──────────────────────────────────

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _incrementBadgeStatic();

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          gardeChannel.id,
          gardeChannel.name,
          channelDescription: gardeChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  // ── Badge ────────────────────────────────────────────────────────────────

  static Future<int> getBadgeCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_badgeKey) ?? 0;
  }

  static Future<void> _incrementBadgeStatic() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_badgeKey) ?? 0;
    await prefs.setInt(_badgeKey, current + 1);
  }

  static Future<void> clearBadge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_badgeKey, 0);
  }

  // ── Token FCM (utile pour les tests manuels) ──────────────────────────────

  static Future<String?> getToken() async {
    return FirebaseMessaging.instance.getToken();
  }
}
