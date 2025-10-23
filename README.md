# 💊 Pharma Niamey — V1

> “Rendre l’accès aux médicaments plus simple, rapide et sûr pour chaque citoyen de Niamey.”

---

## 🌍 À propos

**Pharma Niamey** est une application mobile développée avec **Flutter** qui permet aux utilisateurs de :
- Consulter la **liste des pharmacies de garde** à Niamey.  
- Voir les **coordonnées, adresses et horaires** de chaque pharmacie.  
- Accéder à la **localisation sur carte** (Google Maps).  
- Être informé des **pharmacies ouvertes 24h/24**.  

Cette V1 marque le **lancement officiel du projet**, première étape d’un écosystème de santé digitale moderne au Niger.

---

## 🚀 Fonctionnalités principales (V1)

| Fonctionnalité | Description |
|----------------|-------------|
| 🏥 Liste dynamique des pharmacies de garde | Données synchronisées avec **Firebase Firestore** |
| 🗺️ Localisation via Google Maps | Ouverture directe des cartes depuis l’application |
| ☎️ Contact rapide | Numéro de téléphone accessible en un clic |
| 🔔 Notification visuelle | Badge de notifications (préparation V2) |
| 🎨 Design moderne | Interface fluide, sobre et accessible |
| ☁️ Données Cloud | Données temps réel via **Firebase** |

---

## ⚙️ Stack technique

| Outil / Service | Rôle |
|------------------|------|
| **Flutter 3.x** | Framework mobile multiplateforme |
| **Dart** | Langage principal |
| **Firebase Core / Firestore / Storage / Auth** | Base de données, gestion des utilisateurs et du contenu |
| **Hive** | Cache et données locales (V2) |
| **URL Launcher** | Ouverture des liens de carte et téléphone |
| **Provider** | Gestion d’état (préparée pour la V2) |

---

## 🧱 Architecture projet

lib/
┣ 📁 screens/
┃ ┗ 📄 home_page.dart
┣ 📁 services/
┃ ┗ 📄 firebase_service.dart
┣ 📁 utils/
┃ ┗ 📄 app_theme.dart
┣ 📁 widgets/
┃ ┗ 📄 pharmacy_card.dart
┣ 📁 models/
┃ ┗ 📄 pharmacy_model.dart
┗ 📄 main.dart


🟢 Structure claire et scalable, pensée pour intégrer facilement la **V2 (commande + livraison + authentification)**.

---

## 🧭 Roadmap

| Étape | Statut | Description |
|-------|---------|-------------|
| V1 — Pharmacies de garde | ✅ Terminé | Consultation et affichage des pharmacies |
| V2 — Commande & Livraison | 🔄 En conception | Recherche, commande, upload d’ordonnance |
| V3 — Compte utilisateur & historique | 🔜 À venir | Authentification, suivi des commandes |

---

## 📅 Lancement officiel

- **Date prévue :** 17 novembre 2025  
- **Cible :** utilisateurs de Niamey (17–65 ans)  
- **Objectif :** simplifier l’accès aux pharmacies et moderniser l’expérience santé locale  

---

## 💡 Vision à long terme

Pharma Niamey aspire à devenir :
- Une **plateforme de santé intelligente** pour tout le Niger.  
- Un pont entre **pharmacies, patients et institutions médicales**.  
- Un symbole d’innovation locale portée par la jeunesse nigérienne.  

> “Notre ambition n’est pas seulement de coder une application,  
> mais de construire un écosystème où la santé et la technologie marchent ensemble.”

---

## 👨‍💻 Auteur

**Omar Farouk**  
Fondateur & CEO — *Pharma Niamey*  
- Étudiant en génie logiciel, entrepreneur et développeur full-stack.  
- Passionné par la santé, la technologie et l’impact social.  
- 🇳🇪 Basé à Niamey, Niger.  

📧 [Contact pro à ajouter ultérieurement]  
🌐 [Site web / page Facebook à venir]

---

## 🪪 Licence

© 2025 Pharma Niamey. Tous droits réservés.  
Le code source est propriété du projet et n’est pas distribué publiquement.

---

## ❤️ Remerciements

Un remerciement spécial à :
- Toutes les **pharmacies partenaires** qui participent à la phase pilote.  
- Les **bêta-testeurs** et premiers utilisateurs pour leurs retours constructifs.  
- La **communauté tech nigérienne**, qui inspire et soutient les projets à impact.  

---

> “Ce n’est que le début.  
> Ce projet est né ici, au Niger, avec la conviction que l’innovation locale peut changer des vies.”  
> — *Omar Farouk*
