import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pharma_niamey/app_theme.dart';
import 'package:pharma_niamey/services/firestore_service.dart';
import 'package:pharma_niamey/services/notification_service.dart';
import 'package:pharma_niamey/services/rotation_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  Future<_GuardData>? _guardFuture;

  int _badgeCount = 0;

  @override
  void initState() {
    super.initState();
    _guardFuture = _loadGuardData();
    _loadBadge();
    // Incrémente le badge à chaque notification reçue en premier plan
    FirebaseMessaging.onMessage.listen((_) => _loadBadge());
  }

  Future<void> _loadBadge() async {
    final count = await NotificationService.getBadgeCount();
    if (mounted) setState(() => _badgeCount = count);
  }

  Future<void> _onNotificationTap() async {
    await NotificationService.clearBadge();
    if (mounted) setState(() => _badgeCount = 0);
    _showNotificationPanel();
  }

  void _showNotificationPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _NotificationPanel(guardFuture: _guardFuture),
    );
  }

  Future<_GuardData> _loadGuardData() async {
    final config = await _firestoreService.getRotationConfig();

    final referenceDate = (config['referenceDate'] as Timestamp).toDate();
    final referenceGroupIndex = config['referenceGroupIndex'] as int;
    final cycleOrder = List<int>.from(config['cycleOrder']);

    final groupNumber = RotationService.getCurrentGroupNumber(
      referenceDate: referenceDate,
      referenceGroupIndex: referenceGroupIndex,
      cycleOrder: cycleOrder,
    );

    final range = RotationService.getCurrentGuardRange(
      referenceDate: referenceDate,
    );

    final pharmacies = await _firestoreService.getGroupPharmacies(groupNumber);

    return _GuardData(
      groupNumber: groupNumber,
      pharmacies: pharmacies,
      start: range.start,
      end: range.end,
    );
  }

  void _retry() {
    setState(() {
      _guardFuture = _loadGuardData();
    });
  }

  // ─── Actions ───────────────────────────────────────────────

  void _launchMap(String? url, BuildContext context) async {
    if (url == null || url.isEmpty) {
      if (!context.mounted) return;
      _showSnackBar(context, "Lien de localisation indisponible.", AppColors.error);
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      _showSnackBar(context, "Impossible d'ouvrir la carte.", AppColors.error);
    }
  }

  void _launchPhone(String? phoneNumber, BuildContext context) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      if (!context.mounted) return;
      _showSnackBar(context, "Numéro de téléphone indisponible.", AppColors.error);
      return;
    }

    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('tel:$cleanedNumber');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!context.mounted) return;
      _showSnackBar(
        context,
        "Impossible d'ouvrir l'application téléphone.",
        AppColors.error,
      );
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Row(
          children: [
            Icon(
              color == AppColors.error ? Icons.error_outline : Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  // ─── Widgets ───────────────────────────────────────────────

  Widget _buildRotationHeader(_GuardData data) {
    final dateFormat = DateFormat("EEE d MMM", "fr_FR");
    final startStr = dateFormat.format(data.start);
    final endStr = dateFormat.format(data.end);

    final now = DateTime.now();
    final remaining = data.end.difference(now);
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ligne titre
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.calendar_today,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pharmacies de garde',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Groupe ${data.groupNumber.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${data.pharmacies.length} pharmacies',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dates
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$startStr 13h  →  $endStr 13h',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (days >= 0)
                    Text(
                      days > 0 ? '${days}j ${hours}h' : '${hours}h',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPharmacyCard(Map<String, dynamic> p, BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // ── Fond dégradé ────────────────────────────────────
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFF9FFFD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // ── Décor : croix médicale ──────────────────────────
            Positioned(
              right: -12,
              bottom: -12,
              child: Opacity(
                opacity: 0.06,
                child: Icon(
                  Icons.add_rounded,
                  size: 90,
                  color: AppColors.primary,
                ),
              ),
            ),
            // ── Décor : arcs concentriques ──────────────────────
            Positioned(
              right: 0,
              bottom: 0,
              child: CustomPaint(
                size: const Size(72, 72),
                painter: _CardArcPainter(),
              ),
            ),
            // ── Contenu principal ───────────────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.capsule,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['nom'] ?? 'Pharmacie inconnue',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        if (p['est_ouverte_24h'] == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.success,
                                  AppColors.success.withValues(alpha: 0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.access_time, color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  '24h/24',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildInfoRow(
                icon: CupertinoIcons.location_solid,
                text: 'Quartier : ${p['quartier'] ?? 'Inconnu'}',
                onTap: () => _launchMap(p['map_url'], context),
                isClickable: p['map_url'] != null && p['map_url'].isNotEmpty,
              ),
              const SizedBox(height: 8),

              _buildInfoRow(
                icon: CupertinoIcons.phone_fill,
                text: 'Tél. : ${p['Téléphone'] ?? 'Non communiqué'}',
                onTap: () => _launchPhone(p['Téléphone'], context),
                isClickable:
                    p['Téléphone'] != null && p['Téléphone'].isNotEmpty,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  if (p['Téléphone'] != null && p['Téléphone'].isNotEmpty)
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () => _launchPhone(p['Téléphone'], context),
                        icon: const Icon(Icons.phone, size: 18),
                        label: const Text(
                          'Appeler',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  if (p['Téléphone'] != null && p['Téléphone'].isNotEmpty)
                    const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () => _launchMap(p['map_url'], context),
                      icon: const Icon(CupertinoIcons.map_pin_ellipse, size: 18),
                      label: const Text(
                        'Localiser',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
          ],        // Stack.children
        ),          // Stack
      ),            // Card
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required bool isClickable,
  }) {
    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: MouseRegion(
        cursor: isClickable
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isClickable
                ? AppColors.primary.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isClickable
                ? Border.all(color: AppColors.primary.withValues(alpha: 0.2))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isClickable ? AppColors.primary : AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: isClickable ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isClickable ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (isClickable)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.primary,
                  size: 14,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Pharma Niamey'),
            Text(
              'Pharmacies de garde à Niamey',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _onNotificationTap,
            icon: _badgeCount > 0
                ? Badge(
                    backgroundColor: AppColors.error,
                    label: Text('$_badgeCount'),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.onSurface,
                    ),
                  )
                : const Icon(
                    Icons.notifications_none_outlined,
                    color: AppColors.onSurface,
                  ),
          ),
        ],
      ),
      body: FutureBuilder<_GuardData>(
        future: _guardFuture,
        builder: (context, snapshot) {
          // Chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_pharmacy_rounded,
                    size: 48,
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chargement des pharmacies...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          // Erreur
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 64,
                      color: AppColors.error.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Erreur de chargement',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Impossible de récupérer les pharmacies de garde. '
                      'Vérifiez votre connexion internet.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;

          // Vide
          if (data.pharmacies.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_pharmacy_outlined,
                      size: 64,
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Aucune pharmacie de garde',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les pharmacies de garde seront disponibles prochainement.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Contenu
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildRotationHeader(data),
              const SizedBox(height: 16),
              ...data.pharmacies.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildPharmacyCard(p, context),
                  )),
            ],
          );
        },
      ),
    );
  }
}

// ── Panneau de notifications ────────────────────────────────────────────────

class _NotificationPanel extends StatelessWidget {
  final Future<_GuardData>? guardFuture;
  const _NotificationPanel({this.guardFuture});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("EEE d MMM", "fr_FR");

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poignée
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Titre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Infos sur la garde en cours et la prochaine
          FutureBuilder<_GuardData>(
            future: guardFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data!;
              final nextGroup = (data.groupNumber % 5) + 1;
              final nextStart = data.end;

              return Column(
                children: [
                  _buildInfoTile(
                    context,
                    icon: Icons.check_circle_outline,
                    iconColor: AppColors.success,
                    title: 'Garde en cours — Groupe ${data.groupNumber.toString().padLeft(2, '0')}',
                    subtitle:
                        '${dateFormat.format(data.start)} 13h  →  ${dateFormat.format(data.end)} 13h',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoTile(
                    context,
                    icon: Icons.schedule,
                    iconColor: AppColors.primary,
                    title: 'Prochain changement — Groupe ${nextGroup.toString().padLeft(2, '0')}',
                    subtitle: '${dateFormat.format(nextStart)} à 13h',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          // Info abonnement
          Row(
            children: [
              const Icon(Icons.notifications_active_outlined,
                  size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Vous recevrez une notification chaque samedi à 13h lors du changement de groupe.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Données de garde calculées.
class _GuardData {
  final int groupNumber;
  final List<Map<String, dynamic>> pharmacies;
  final DateTime start;
  final DateTime end;

  const _GuardData({
    required this.groupNumber,
    required this.pharmacies,
    required this.start,
    required this.end,
  });
}

/// Peint deux arcs concentriques dans le coin bas-droit d'une card.
class _CardArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width, size.height);

    // Arc intérieur
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * 0.45),
      -math.pi / 2,
      -math.pi / 2,
      false,
      paint,
    );

    // Arc extérieur
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * 0.80),
      -math.pi / 2,
      -math.pi / 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CardArcPainter oldDelegate) => false;
}
