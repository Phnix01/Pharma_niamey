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