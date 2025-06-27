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
        title: const Text('Pharmacies de Garde'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 1,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pharmacies_de_garde')
            .orderBy(FieldPath.documentId, descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == "waiting") {}
          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
                semanticsLabel: "Chargement encours",
                backgroundColor: Colors.amber,
              ),
            );

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Aucune donnée disponible.'));
          }

          return ListView.builder(
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
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        child: ListTile(
                          title: Text(p['nom']),
                          subtitle: Text('${p['quartier']} • ${p['adresse']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.map, color: Colors.green),
                            onPressed: () => _launchMap(p['map_url'], context),
                          ),
                          leading: p['est_ouverte_24h'] == true
                              ? const Icon(
                                  Icons.access_time,
                                  color: Colors.orange,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
