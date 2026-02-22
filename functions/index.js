/**
 * Cloud Functions — Pharma Niamey
 *
 * Fonction planifiée : envoie une notification FCM à tous les abonnés du
 * topic "garde_active" chaque samedi à 13h00 (heure Niamey, UTC+1).
 *
 * Déploiement :
 *   cd functions
 *   npm install
 *   firebase deploy --only functions
 */

const { onSchedule } = require("firebase-functions/v2/scheduler");
const { initializeApp } = require("firebase-admin/app");
const { getMessaging } = require("firebase-admin/messaging");
const { getFirestore, Timestamp } = require("firebase-admin/firestore");

initializeApp();

// ── Utilitaire : numéro de groupe actif ─────────────────────────────────────

function getCurrentGroupNumber(referenceDate, referenceGroupIndex, cycleOrder) {
  const now = new Date();
  const diffHours = (now - referenceDate) / (1000 * 60 * 60);
  const weeksSince =
    diffHours >= 0
      ? Math.floor(diffHours / (7 * 24))
      : -Math.ceil(-diffHours / (7 * 24));

  const index =
    ((referenceGroupIndex + weeksSince) % cycleOrder.length + cycleOrder.length) %
    cycleOrder.length;
  return cycleOrder[index];
}

// ── Cloud Function : chaque samedi à 13h00 WAT (12h00 UTC) ─────────────────

exports.sendGardeNotification = onSchedule(
  {
    schedule: "0 12 * * 6", // CRON : minute=0, heure=12 UTC, chaque samedi
    timeZone: "UTC",
    region: "europe-west1",
  },
  async () => {
    const db = getFirestore();

    // Récupérer la config de rotation
    const configDoc = await db.collection("config").doc("rotation").get();
    if (!configDoc.exists) {
      console.error("Document config/rotation introuvable.");
      return;
    }

    const config = configDoc.data();
    const referenceDate = config.referenceDate.toDate();
    const referenceGroupIndex = config.referenceGroupIndex;
    const cycleOrder = config.cycleOrder;

    const groupNumber = getCurrentGroupNumber(
      referenceDate,
      referenceGroupIndex,
      cycleOrder
    );
    const groupId = `groupe_${String(groupNumber).padStart(2, "0")}`;

    // Récupérer le nombre de pharmacies du groupe actif
    const groupeDoc = await db.collection("groupes").doc(groupId).get();
    const pharmacies = groupeDoc.exists
      ? groupeDoc.data().pharmacies ?? []
      : [];

    const groupLabel = `Groupe ${String(groupNumber).padStart(2, "0")}`;

    // Construire la notification FCM
    const message = {
      topic: "garde_active",
      notification: {
        title: `🏥 ${groupLabel} en garde`,
        body:
          pharmacies.length > 0
            ? `${pharmacies.length} pharmacies disponibles dès maintenant.`
            : "Les pharmacies de garde viennent de changer.",
      },
      android: {
        notification: {
          channelId: "garde_channel",
          priority: "high",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      },
      data: {
        type: "garde_change",
        groupNumber: String(groupNumber),
      },
    };

    const response = await getMessaging().send(message);
    console.log(`Notification envoyée (${groupLabel}) — messageId: ${response}`);
  }
);
