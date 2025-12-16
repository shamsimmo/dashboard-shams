# Configuration du Module Avancement des Travaux

## Vue d'ensemble

Le module d'avancement des travaux a été intégré avec succès. Il permet de :

**Côté Agence :**
- Définir la date de début des travaux pour chaque projet
- Créer et gérer des jalons (milestones) avec statuts
- Télécharger des images d'avancement
- Notifications automatiques aux clients

**Côté Client :**
- Espace client dédié avec navigation
- Dashboard avec résumé de l'acquisition
- Page de suivi d'avancement des travaux
- Compte à rebours jusqu'à la livraison
- Timeline des jalons du projet
- Galerie d'images d'avancement
- Notifications de mises à jour

## Configuration Requise

### Bucket de Stockage Supabase

Les images d'avancement sont stockées dans le bucket `progress-images` de Supabase Storage.

**Statut** : ✅ Bucket créé et politiques RLS configurées automatiquement

Les politiques de sécurité suivantes sont en place :
- Collaborateurs authentifiés peuvent uploader, modifier et supprimer des images
- Accès public en lecture pour toutes les images (visibles par les clients)
- Images organisées par projet dans des sous-dossiers

## Utilisation

### Côté Agence

1. **Accéder au module**
   - Menu > Projets > Avancement

2. **Sélectionner un projet**
   - Utilisez le filtre pour choisir un projet
   - Optionnellement, filtrez par aile

3. **Définir la date de début des travaux**
   - Renseignez la date dans le champ prévu
   - Cliquez sur le bouton de sauvegarde
   - Cette date sera utilisée pour le compte à rebours côté client

4. **Gérer les jalons**
   - Cliquez sur "Ajouter un jalon"
   - Remplissez les informations :
     - Nom du jalon (ex: "Planification", "Fondations", etc.)
     - Description
     - Position dans la timeline
     - Statut (Non démarré / En cours / Terminé)
     - Dates de début et de fin
   - Les jalons sont affichés dans l'ordre de position

5. **Ajouter des images**
   - Cliquez sur "Ajouter des images"
   - Sélectionnez l'image à télécharger
   - Associez-la à un jalon (optionnel)
   - Ajoutez une légende
   - Définissez la date de prise de vue
   - Téléchargez

### Notifications Automatiques

Le système envoie automatiquement des notifications aux clients dans les cas suivants :

1. **Jalon terminé**
   - Lorsqu'un jalon passe au statut "Terminé"
   - Tous les clients ayant un plan de paiement validé reçoivent une notification

2. **Nouvelles images**
   - À chaque ajout d'image d'avancement
   - Notification envoyée à tous les clients concernés

## Structure des Tables

### `project_milestones`
- Jalons d'un projet avec ordre, statut, et dates

### `project_progress_images`
- Images d'avancement liées à un projet et optionnellement à un jalon

### `client_notifications`
- Notifications pour les clients (jalons terminés, nouvelles images)

## Points d'Attention

1. **Ordre des jalons**
   - L'ordre est défini par le champ `order_position`
   - Pensez à numéroter vos jalons de manière cohérente (1, 2, 3...)

2. **Statuts des jalons**
   - **Non démarré** : Jalon futur
   - **En cours** : Travaux en cours
   - **Terminé** : Jalon accompli (déclenche une notification)

3. **Images**
   - Formats acceptés : JPG, PNG, WEBP
   - Taille maximale : Selon configuration du bucket
   - Les images sont publiques et accessibles via URL

4. **Notifications**
   - Automatiques via triggers PostgreSQL
   - Visibles dans `client_notifications`
   - Seuls les clients avec statut "client" et plan validé sont notifiés

## Espace Client

L'espace client est maintenant fonctionnel et accessible via `/client/login`.

### Fonctionnalités Implémentées

#### 1. **Dashboard Client**
   - Vue d'ensemble de l'acquisition immobilière
   - Informations détaillées sur le projet (nom, adresse, dates)
   - Liste des lots achetés avec :
     - Numéro, type et surface
     - Prix TTC et statut
     - Vue (si renseignée)
   - Résumé du plan de paiement
   - Actions rapides vers les autres sections

#### 2. **Page Avancement**
   - **Compte à Rebours** en temps réel jusqu'à la livraison
     - Affichage en jours, heures, minutes et secondes
     - Mise à jour automatique chaque seconde
   - **Timeline des Jalons** :
     - Liste complète des jalons du projet
     - Icônes visuelles selon le statut
     - Code couleur (vert: terminé, bleu: en cours, rouge: retardé, gris: à venir)
     - Descriptions et dates prévues
   - **Galerie Photos** :
     - Grille d'images d'avancement
     - Légendes et dates de publication
     - Vue plein écran au clic
     - Affichage chronologique inversé (plus récentes en premier)

#### 3. **Navigation**
   - Menu avec 3 sections : Accueil, Avancement, Documents
   - Design responsive (mobile et desktop)
   - Profil client visible avec nom et email
   - Bouton de déconnexion

### À Développer

1. **Section Documents**
   - Plans 2D et 3D
   - Contrats et documents légaux
   - Certificats et attestations

2. **Centre de Notifications**
   - Badge de notifications non lues
   - Liste des notifications
   - Marquage comme lu

3. **Interactions Avancées**
   - Téléchargement de documents
   - Historique des paiements détaillé
   - Messagerie avec l'agence

## Support

Pour toute question ou problème, vérifiez :
- Les logs de la console navigateur
- Les politiques RLS dans Supabase
- La configuration du bucket Storage
- Les triggers de notification dans PostgreSQL
