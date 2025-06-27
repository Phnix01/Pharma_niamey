import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String todayKey;

  @override
  void initState() {
    super.initState();
    todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<List<Map<String, dynamic>>> fetchPharmacies() async {
    final doc = await FirebaseFirestore.instance
        .collection('pharmacies_de_garde')
        .doc(todayKey)
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      final List pharmacies = data['pharmacies'] ?? [];
      return pharmacies.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }

  void _launchMap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir la carte.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pharmacies de Garde',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 1,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPharmacies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('Erreur ou aucune donnée trouvée.'),
            );
          }

          final pharmacies = snapshot.data!;
          if (pharmacies.isEmpty) {
            return const Center(
              child: Text('Aucune pharmacie de garde aujourd\'hui.'),
            );
          }

          return ListView.builder(
            itemCount: pharmacies.length,
            itemBuilder: (context, index) {
              final pharmacy = pharmacies[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  title: Text(pharmacy['nom']),
                  subtitle: Text(
                    '${pharmacy['quartier']} • ${pharmacy['adresse']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.map, color: Colors.green),
                    onPressed: () => _launchMap(pharmacy['map_url']),
                  ),
                  leading: pharmacy['est_ouverte_24h'] == true
                      ? const Icon(Icons.access_time, color: Colors.orange)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
