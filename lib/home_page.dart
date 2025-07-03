import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _launchMap(String url, BuildContext context) async {
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
          softWrap: true,
          textAlign: TextAlign.justify,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 1,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pharmacies_de_garde')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Icon(Icons.warning, size: 30, color: Colors.red),
                  Text("Aucune donnée disponible"),
                ],
              ),
            );
          }
          final docs = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final semaine = data['semaine'] ?? 'Semaine inconnue';
                final pharmacies = List<Map<String, dynamic>>.from(
                  data['pharmacies'] ?? [],
                );

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📅 $semaine',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...pharmacies.map(
                        (p) => Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nom de la pharmacie + badge 24h
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        p['nom'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (p['est_ouverte_24h'] == true)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Text(
                                          'Ouvert 24h',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Quartier + Commune
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${p['quartier']} • ${p['Commune']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                // Téléphone
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${p['Téléphone']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Bouton vers la carte
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () =>
                                        _launchMap(p['map_url'], context),
                                    icon: const Icon(
                                      Icons.map,
                                      color: Colors.green,
                                    ),
                                    label: const Text(
                                      'Voir sur la carte',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
