// ============================================================
// DONNÉES FIRESTORE — Pharma Niamey
// ============================================================
// Ce fichier sert de référence pour saisir les données
// dans la console Firebase (https://console.firebase.google.com)
//
// STRUCTURE :
//   Collection "config"  → Document "rotation"
//   Collection "groupes" → Documents "groupe_01" à "groupe_05"
//
// INSTRUCTIONS :
//   1. Aller dans Firestore Database
//   2. Créer la collection "config" avec le document "rotation"
//   3. Créer la collection "groupes" avec les 5 documents
//   4. Copier les données ci-dessous pour chaque document
//   5. Compléter les champs marqués "TODO"
// ============================================================


// ─── COLLECTION : config ─────────────────────────────────────
// Document ID : "rotation"
const rotation = {
  // Date de référence : le samedi où le Groupe 01 commence sa garde
  // Dans Firestore, créer ce champ en type "timestamp"
  // Valeur : 14 février 2026 à 13:00:00 (heure de Niamey, UTC+1)
  referenceDate: new Date("2026-02-14T12:00:00Z"), // 13h Niamey = 12h UTC

  // Index du groupe de référence dans cycleOrder (0 = premier élément)
  referenceGroupIndex: 0,

  // Ordre de rotation des groupes
  // Chaque samedi à 13h, on passe au groupe suivant dans cette liste
  cycleOrder: [1, 2, 3, 4, 5],
};


// ─── COLLECTION : groupes ────────────────────────────────────

// Document ID : "groupe_01"
const groupe_01 = {
  nom: "Groupe 01",
  pharmacies: [
    {
      nom: "Pharmacie Nouvelle",
      quartier: "Plateau",            // TODO: vérifier
      Commune: "Niamey I",            // TODO: vérifier
      "Téléphone": "",                // TODO: ajouter le numéro
      map_url: "",                    // TODO: ajouter le lien Google Maps
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Populaire",
      quartier: "Grand Marché",
      Commune: "Niamey I",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Askia",
      quartier: "Askia",
      Commune: "Niamey II",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Ténéré",
      quartier: "Ténéré",
      Commune: "Niamey III",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Lacouroussou",
      quartier: "Lacouroussou",
      Commune: "Niamey IV",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Dar Es Salam",
      quartier: "Dar Es Salam",
      Commune: "Niamey V",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    // TODO: ajouter les autres pharmacies du Groupe 01
  ],
};

// Document ID : "groupe_02"
const groupe_02 = {
  nom: "Groupe 02",
  pharmacies: [
    {
      nom: "Pharmacie du Grand Hôtel",
      quartier: "Plateau",
      Commune: "Niamey I",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Gamkalley",
      quartier: "Gamkalley",
      Commune: "Niamey I",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Yantala",
      quartier: "Yantala",
      Commune: "Niamey II",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Liberté",
      quartier: "Liberté",
      Commune: "Niamey III",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Talladjé",
      quartier: "Talladjé",
      Commune: "Niamey IV",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Saga",
      quartier: "Saga",
      Commune: "Niamey V",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    // TODO: ajouter les autres pharmacies du Groupe 02
  ],
};

// Document ID : "groupe_03"
const groupe_03 = {
  nom: "Groupe 03",
  pharmacies: [
    {
      nom: "Pharmacie Point D",
      quartier: "Rond Point D",
      Commune: "Niamey I",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Maourey",
      quartier: "Maourey",
      Commune: "Niamey II",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Bobiel",
      quartier: "Bobiel",
      Commune: "Niamey III",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Koira Kano",
      quartier: "Koira Kano",
      Commune: "Niamey IV",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Lamordé",
      quartier: "Lamordé",
      Commune: "Niamey V",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    // TODO: ajouter les autres pharmacies du Groupe 03
  ],
};

// Document ID : "groupe_04"
const groupe_04 = {
  nom: "Groupe 04",
  pharmacies: [
    {
      nom: "Pharmacie Soleil",
      quartier: "Plateau",
      Commune: "Niamey I",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Wadata",
      quartier: "Wadata",
      Commune: "Niamey II",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Lazaret",
      quartier: "Lazaret",
      Commune: "Niamey III",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Route Filingué",
      quartier: "Route Filingué",
      Commune: "Niamey IV",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Francophonie",
      quartier: "Francophonie",
      Commune: "Niamey V",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    // TODO: ajouter les autres pharmacies du Groupe 04
  ],
};

// Document ID : "groupe_05"
const groupe_05 = {
  nom: "Groupe 05",
  pharmacies: [
    {
      nom: "Pharmacie Terminus",
      quartier: "Terminus",
      Commune: "Niamey I",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Kalley",
      quartier: "Kalley",
      Commune: "Niamey II",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Cité Caisse",
      quartier: "Cité Caisse",
      Commune: "Niamey III",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Sonuci",
      quartier: "Sonuci",
      Commune: "Niamey IV",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    {
      nom: "Pharmacie Gaweye",
      quartier: "Gaweye",
      Commune: "Niamey V",
      "Téléphone": "",
      map_url: "",
      est_ouverte_24h: false,
    },
    // TODO: ajouter les autres pharmacies du Groupe 05
  ],
};


// ============================================================
// GUIDE DE SAISIE DANS FIRESTORE
// ============================================================
//
// ÉTAPE 1 : Créer la collection "config"
//   → Ajouter un document avec l'ID "rotation"
//   → Champs :
//      - referenceDate     (timestamp) → 14/02/2026 13:00:00
//      - referenceGroupIndex (number)  → 0
//      - cycleOrder         (array)    → [1, 2, 3, 4, 5]
//
// ÉTAPE 2 : Créer la collection "groupes"
//   → Ajouter un document avec l'ID "groupe_01"
//   → Champs :
//      - nom         (string) → "Groupe 01"
//      - pharmacies  (array)  → chaque élément est une map avec :
//          - nom              (string)  → "Pharmacie Nouvelle"
//          - quartier         (string)  → "Plateau"
//          - Commune          (string)  → "Niamey I"
//          - Téléphone        (string)  → "+227 20 XX XX XX"
//          - map_url          (string)  → "https://maps.google.com/..."
//          - est_ouverte_24h  (boolean) → false
//
//   → Répéter pour groupe_02, groupe_03, groupe_04, groupe_05
//
// ============================================================
// IMPORTANT : Les noms de pharmacies ci-dessus sont des exemples
// basés sur les images partagées. Vérifiez et complétez chaque
// groupe avec les vraies données de votre programmation.
// ============================================================
