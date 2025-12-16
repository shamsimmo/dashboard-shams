# SHAMS IMMO - Dashboard de Gestion Immobilière VEFA

Application web complète pour la gestion de projets immobiliers en Vente en État Futur d'Achèvement (VEFA).

## Fonctionnalités

### Gestion des données
- **Projets** : Créez et gérez vos projets immobiliers avec localisation et pourcentage minimum d'apport
- **Ailes** : Organisez vos bâtiments par ailes avec exposition (Nord/Sud/Est/Ouest)
- **Lots** : Gérez les appartements et duplex avec calculs automatiques de prix
  - Import groupé via CSV/Excel
  - Calculs automatiques : prix habitable, balcon, mezzanine, parking
- **Clients** : Base de données clients avec coordonnées complètes
- **Collaborateurs** : Gestion des utilisateurs (Administrateurs et Commerciaux)

### Simulateur de Plan de Paiement
- Sélection projet / aile / lot / client
- Configuration du premier apport (% et montant)
- **Mode automatique** : Répartition égale (trimestriel, semestriel, annuel)
- **Mode personnalisé** : Jusqu'à 18 échéances sur mesure
- Association du parking à une échéance spécifique
- Conversion automatique EUR ↔ MAD

### Gestion des Plans de Paiement
- Statuts : En attente / Validé / Refusé
- Validation avec date réelle de paiement
- Suivi de progression par échéance
- Génération de PDF professionnels
- Envoi par email ou WhatsApp

### Réglages
- **Paramètres financiers** : Taux MAD, frais de dossier
- **Profil agence** : Informations légales complètes (ICE, adresse, représentant)
- **Intégration HubSpot** : Synchronisation automatique des leads vers la table prospects

### Génération PDF
- Design professionnel avec dégradé doré
- Informations société complètes
- Détails client, projet, lot
- Échéances avec dates et montants (EUR + MAD)
- Taux de change appliqué

## Installation

### Prérequis
- Node.js 18+
- Compte Supabase

### Configuration

1. Cloner le projet et installer les dépendances :
```bash
npm install
```

2. Configurer les variables d'environnement dans `.env` :
```
VITE_SUPABASE_URL=votre_url_supabase
VITE_SUPABASE_ANON_KEY=votre_cle_anonyme
```

3. Les migrations de base de données ont déjà été appliquées via Supabase.

### Créer le premier administrateur

Vous devez créer un utilisateur manuellement dans Supabase :

1. Allez dans votre projet Supabase > Authentication > Users
2. Cliquez sur "Add user" et créez un compte avec email/mot de passe
3. Notez l'ID de l'utilisateur créé
4. Allez dans SQL Editor et exécutez :

```sql
INSERT INTO collaborators (id, first_name, last_name, email, phone, role)
VALUES (
  'ID_UTILISATEUR_SUPABASE',
  'Prénom',
  'Nom',
  'email@example.com',
  '+212600000000',
  'admin'
);
```

### Lancer l'application

```bash
npm run dev
```

L'application sera accessible sur `http://localhost:5173`

## Service de Synchronisation HubSpot (Optionnel)

Un service Node.js autonome permet de synchroniser automatiquement les leads HubSpot vers une table `prospects` dans Supabase.

### Fonctionnalités
- Synchronisation automatique toutes les 5 minutes
- Import uniquement des leads créés après le 01/12/2025
- Évite les doublons automatiquement
- Gestion incrémentale des synchronisations
- Logs détaillés

### Installation

```bash
cd services
npm install
cp .env.example .env
# Éditer .env avec vos credentials
npm start
```

Pour plus de détails, voir :
- [Guide de démarrage rapide](./services/QUICK_START.md)
- [Documentation complète](./services/README.md)
- [Guide de déploiement](./services/DEPLOYMENT.md)

## Utilisation

### Connexion
Utilisez l'email et le mot de passe du compte administrateur créé.

### Workflow typique

1. **Configuration initiale**
   - Allez dans Réglages pour configurer le taux MAD et le profil agence
   - Ajoutez des collaborateurs si nécessaire

2. **Création de projets**
   - Créez vos projets immobiliers
   - Ajoutez les ailes correspondantes
   - Importez ou créez les lots

3. **Gestion clients**
   - Ajoutez vos clients avec leurs coordonnées

4. **Simulation et plans**
   - Utilisez le simulateur pour créer des plans de paiement
   - Validez les plans acceptés par les clients
   - Générez et envoyez les PDF

### Import CSV pour les lots

Le template CSV doit contenir les colonnes suivantes :
- reference
- type (Appartement ou Duplex)
- nb_bedrooms
- surface_habitable
- surface_totale
- surface_balcon
- surface_mezzanine
- price_m2_habitable
- price_m2_balcon
- parking_included (true/false)
- parking_price

## Architecture Technique

### Frontend
- React 18 + TypeScript
- Tailwind CSS pour le design
- Lucide React pour les icônes
- jsPDF pour la génération de PDF

### Backend
- Supabase (PostgreSQL + Auth)
- Row Level Security (RLS) pour la sécurité
- Calculs automatiques via colonnes générées

### Sécurité
- Authentification sécurisée par email/mot de passe
- Politiques RLS restrictives
- Validation des pourcentages (somme = 100%)
- Rôles Administrateur/Commercial

## Support

Pour toute question ou problème :
- Vérifiez que toutes les migrations sont appliquées
- Vérifiez les variables d'environnement
- Consultez la console pour les erreurs

## Technologies

- React 18.3
- TypeScript 5.5
- Vite 5.4
- Tailwind CSS 3.4
- Supabase 2.57
- jsPDF
- Lucide React

## Licence

Propriétaire - SHAMS IMMO
