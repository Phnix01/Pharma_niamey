import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  /// Récupère la configuration de rotation depuis Firestore.
  /// Retourne : { referenceDate, referenceGroupIndex, cycleOrder }
  Future<Map<String, dynamic>> getRotationConfig() async {
    final doc = await _db.collection('config').doc('rotation').get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Configuration de rotation introuvable dans Firestore.');
    }
    return doc.data()!;
  }

  /// Récupère les pharmacies d'un groupe donné (ex: groupe_01, groupe_02...)
  Future<List<Map<String, dynamic>>> getGroupPharmacies(int groupNumber) async {
    final docId = 'groupe_${groupNumber.toString().padLeft(2, '0')}';
    final doc = await _db.collection('groupes').doc(docId).get();
    if (!doc.exists || doc.data() == null) {
      return [];
    }
    return List<Map<String, dynamic>>.from(doc.data()!['pharmacies'] ?? []);
  }
}
