class RotationService {
  /// Calcule le numéro du groupe de garde pour une date donnée.
  ///
  /// [referenceDate] : un samedi 13h où la rotation commence (ex: 14 fév 2026 13:00)
  /// [referenceGroupIndex] : index du groupe actif à cette date dans [cycleOrder]
  /// [cycleOrder] : ordre des groupes (ex: [1, 2, 3, 4, 5])
  static int getCurrentGroupNumber({
    required DateTime referenceDate,
    required int referenceGroupIndex,
    required List<int> cycleOrder,
    DateTime? now,
  }) {
    final currentDate = now ?? DateTime.now();
    final diffHours = currentDate.difference(referenceDate).inHours;

    // Si on est avant la date de référence, remonter dans le cycle
    final weeksSince = diffHours >= 0
        ? diffHours ~/ (7 * 24)
        : -(((-diffHours) + (7 * 24) - 1) ~/ (7 * 24));

    final index =
        ((referenceGroupIndex + weeksSince) % cycleOrder.length + cycleOrder.length) %
            cycleOrder.length;
    return cycleOrder[index];
  }

  /// Retourne la date de début et de fin de la garde en cours.
  static ({DateTime start, DateTime end}) getCurrentGuardRange({
    required DateTime referenceDate,
    DateTime? now,
  }) {
    final currentDate = now ?? DateTime.now();
    final diffHours = currentDate.difference(referenceDate).inHours;

    final weeksSince = diffHours >= 0
        ? diffHours ~/ (7 * 24)
        : -(((-diffHours) + (7 * 24) - 1) ~/ (7 * 24));

    final start = referenceDate.add(Duration(days: weeksSince * 7));
    final end = start.add(const Duration(days: 7));
    return (start: start, end: end);
  }
}
