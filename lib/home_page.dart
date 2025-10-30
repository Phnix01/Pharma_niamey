import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF00BFA6);
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _launchMap(String? url, BuildContext context) async {
    if (url == null || url.isEmpty) {
      _showSnackBar(context, "Lien de localisation indisponible.", Colors.red);
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar(context, "Impossible d'ouvrir la carte.", Colors.red);
    }
  }

  void _launchPhone(String? phoneNumber, BuildContext context) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      _showSnackBar(context, "Numéro de téléphone indisponible.", Colors.red);
      return;
    }

    // Nettoyer le numéro de téléphone
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('tel:$cleanedNumber');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showSnackBar(
        context,
        "Impossible d'ouvrir l'application téléphone.",
        Colors.red,
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
              color == Colors.red ? Icons.error_outline : Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF9FFFD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec badge 24h
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.capsule,
                      color: Color(0xFF00BFA6),
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1C1C1E),
                          ),
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
                                  Colors.green.shade400,
                                  Colors.green.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '24h/24',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
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

              // Informations de contact
              _buildInfoRow(
                icon: CupertinoIcons.location_solid,
                text:
                    '${p['quartier'] ?? 'Quartier inconnu'} • ${p['Commune'] ?? 'Commune inconnue'}',
                onTap: () => _launchMap(p['map_url'], context),
                isClickable: p['map_url'] != null && p['map_url'].isNotEmpty,
              ),
              const SizedBox(height: 8),

              _buildInfoRow(
                icon: CupertinoIcons.phone_fill,
                text: p['Téléphone'] ?? 'Non communiqué',
                onTap: () => _launchPhone(p['Téléphone'], context),
                isClickable:
                    p['Téléphone'] != null && p['Téléphone'].isNotEmpty,
              ),
              const SizedBox(height: 16),

              // Boutons d'action
              Row(
                children: [
                  // Bouton Appeler
                  if (p['Téléphone'] != null && p['Téléphone'].isNotEmpty)
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
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

                  // Bouton Localisation
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () => _launchMap(p['map_url'], context),
                      icon: const Icon(
                        CupertinoIcons.map_pin_ellipse,
                        size: 18,
                      ),
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
      ),
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
                ? primaryColor.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isClickable
                ? Border.all(color: primaryColor.withOpacity(0.2))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isClickable ? primaryColor : Colors.grey.shade600,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: isClickable ? primaryColor : Colors.grey.shade700,
                    fontWeight: isClickable
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (isClickable)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: primaryColor,
                  size: 14,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekHeader(String semaine) {
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
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.1),
              primaryColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.calendar_today,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                semaine,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007A6E),
                  letterSpacing: 0.3,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Pharmacies de garde',
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              'Pharma Niamey',
              style: TextStyle(
                color: Color(0xFF00BFA6),
                fontWeight: FontWeight.bold,
                fontSize: 21,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Pharmacies de garde à Niamey',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Badge(
              backgroundColor: Colors.redAccent,
              label: const Text("4"),
              child: const Icon(Icons.notifications_none_outlined),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pharmacies_de_garde')
            .orderBy('dateCreation', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 16),
                  const Text(
                    'Chargement des pharmacies...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_pharmacy_outlined,
                    size: 60,
                    color: primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Aucune pharmacie de garde disponible",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final semaine = data['semaine'] ?? 'Semaine inconnue';
              final pharmacies = List<Map<String, dynamic>>.from(
                data['pharmacies'] ?? [],
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeekHeader(semaine),
                  const SizedBox(height: 12),
                  ...pharmacies.map((p) => _buildPharmacyCard(p, context)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
