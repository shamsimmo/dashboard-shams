# Guide Utilisateur - SHAMS IMMO

## Table des matières
1. [Première connexion](#première-connexion)
2. [Configuration initiale](#configuration-initiale)
3. [Gestion des projets](#gestion-des-projets)
4. [Création de plans de paiement](#création-de-plans-de-paiement)
5. [Validation et génération PDF](#validation-et-génération-pdf)

## Première connexion

### Création du compte administrateur
1. Dans Supabase Authentication, créez un utilisateur avec email/mot de passe
2. Exécutez le script SQL fourni dans `FIRST_ADMIN_SETUP.sql`
3. Connectez-vous avec vos identifiants

### Interface principale
- **Sidebar gauche** : Navigation entre les sections
- **Header** : Titre de la page actuelle
- **Zone principale** : Contenu de la page

## Configuration initiale

### 1. Profil de l'agence
Allez dans **Réglages** > Section "Profil de l'agence"

Renseignez :
- Nom de l'agence : SHAMS IMMO
- Forme juridique : SARL, SAS, etc.
- Adresse complète (ligne 1, ligne 2, ville, code postal, pays)
- Numéro ICE
- Téléphone de l'agence
- Email de l'agence
- Représentant légal (ex: "Mohammed ALAMI, Gérant")

Ces informations apparaîtront sur tous les PDF générés.

### 2. Paramètres financiers
Toujours dans **Réglages** > Section "Paramètres financiers"

Configurez :
- **Taux de change** : 1 EUR = X MAD (ex: 10.5)
- **Frais de dossier** : Cochez si applicable et indiquez le montant

### 3. Collaborateurs
Si vous avez d'autres commerciaux ou administrateurs :
1. Allez dans **Collaborateurs**
2. Cliquez sur "Nouveau collaborateur"
3. Remplissez le formulaire
4. Choisissez le rôle :
   - **Administrateur** : Accès complet, peut gérer les utilisateurs et paramètres
   - **Commercial** : Peut créer des plans de paiement mais pas modifier les paramètres

## Gestion des projets

### Créer un projet
1. Allez dans **Projets**
2. Cliquez sur "Nouveau projet"
3. Renseignez :
   - Nom du projet
   - Localisation
   - Nombre total de lots
   - Pourcentage minimum du premier apport (ex: 20, 25, 30...)

### Créer les ailes
1. Allez dans **Ailes**
2. Cliquez sur "Nouvelle aile"
3. Sélectionnez le projet
4. Indiquez :
   - Nom de l'aile (ex: Aile A, Bâtiment Nord)
   - Nombre d'étages
   - Exposition (Nord/Sud/Est/Ouest)

### Créer les lots

#### Méthode 1 : Saisie manuelle
1. Allez dans **Lots**
2. Cliquez sur "Nouveau lot"
3. Remplissez tous les champs :
   - Projet et Aile
   - Référence du lot
   - Type (Appartement / Duplex)
   - Nombre de chambres
   - Surfaces (habitable, totale, balcon, mezzanine)
   - Prix au m² (habitable et balcon)
   - Parking (cochez si inclus et indiquez le prix)

Le **prix total** est calculé automatiquement.

#### Méthode 2 : Import CSV
1. Cliquez sur "Import CSV"
2. Téléchargez le template
3. Remplissez le fichier Excel/CSV
4. Importez le fichier
5. Vérifiez les données et validez

### Gérer les clients
1. Allez dans **Clients**
2. Cliquez sur "Nouveau client"
3. Renseignez :
   - Prénom et Nom
   - Email
   - Téléphone
   - Numéro WhatsApp (pour l'envoi des PDF)

## Création de plans de paiement

### Accéder au simulateur
1. Allez dans **Simulateur**
2. Suivez les 4 étapes

### Étape 1 : Sélection du bien
- Choisissez le client
- Sélectionnez le projet
- Sélectionnez l'aile (optionnel)
- Choisissez le lot

Un récapitulatif s'affiche avec :
- Prix du lot
- Frais de dossier (si activés)
- Total en EUR et MAD

### Étape 2 : Premier apport
- **Pourcentage** : Minimum celui défini sur le projet
  - Le système bloque si vous entrez moins
- **Date prévue** : Date de règlement prévue
- Montants calculés automatiquement (EUR et MAD)

### Étape 3 : Mode de paiement

#### Mode Automatique
Répartition égale du reste à payer sur :
- **Trimestriel** : Échéances tous les 3 mois
- **Semestriel** : Échéances tous les 6 mois
- **Annuel** : Échéances tous les 12 mois

Le système génère automatiquement les échéances avec dates suggérées.

#### Mode Personnalisé
- Choisissez le nombre d'échéances (1 à 18)
- Pour chaque échéance :
  - Indiquez le **pourcentage** du total global
  - Modifiez la **date** si nécessaire
  - Si le lot inclut un parking, cochez "Associer le parking à cette échéance"

**IMPORTANT** :
- Le parking doit être associé à **UNE SEULE** échéance
- La somme de tous les pourcentages (premier apport + échéances) doit être **exactement 100%**
- Sinon, le système affichera une erreur

### Étape 4 : Validation
- Vérifiez toutes les échéances
- Le récapitulatif montre la somme des pourcentages
- Cliquez sur "Enregistrer le plan"

Le plan est créé avec le statut **"En attente"**.

## Validation et génération PDF

### Consulter les plans
1. Allez dans **Plans de paiement**
2. Vous voyez tous les plans avec :
   - Client
   - Projet / Lot
   - Montant total
   - Statut (En attente / Validé / Refusé)
   - Créateur
   - Date de création

### Voir les détails
Cliquez sur l'icône œil pour voir :
- Toutes les informations du client et du bien
- Détails financiers complets
- Liste des échéances avec dates et montants

### Valider un plan
1. Ouvrez les détails du plan
2. Cliquez sur "Valider"
3. **Renseignez la date réelle du premier apport**
   - Peut être différente de la date prévue initialement
4. Confirmez

Le plan passe en statut **"Validé"**.

À ce moment, vous pouvez :
- Modifier les dates des échéances restantes (uniquement les dates, pas les montants)
- Les montants et pourcentages sont gelés

### Générer le PDF
Une fois validé :
1. Cliquez sur "Télécharger PDF"
2. Le PDF professionnel est généré avec :
   - En-tête SHAMS IMMO avec dégradé doré
   - Bloc "Informations de la société" (vos coordonnées)
   - Informations client complètes
   - Détails du projet et du lot
   - Calcul détaillé des prix (habitable, balcon, mezzanine, parking)
   - Total EUR et MAD
   - Premier apport avec date de règlement
   - Toutes les échéances avec :
     - Numéro
     - Date
     - Pourcentage
     - Montant EUR et MAD
     - Mention si l'échéance inclut le parking
   - Taux de change appliqué
   - Nom du créateur et date de création

### Envoyer le PDF
- **Email** : Fonction à implémenter selon vos besoins
- **WhatsApp** : Cliquez sur "Envoyer WhatsApp"
  - Ouvre WhatsApp Web avec le numéro du client
  - Message pré-rempli
  - Vous pouvez ensuite joindre le PDF manuellement

### Refuser un plan
Si le client refuse :
1. Ouvrez les détails
2. Cliquez sur "Refuser"
3. Indiquez le motif (optionnel)

Le plan passe en statut **"Refusé"** et reste modifiable.

## Suivi de progression

### Tableau de bord
Le **Dashboard** affiche :
- Nombre de projets
- Nombre d'ailes
- Nombre de lots
- Nombre de clients
- Nombre de plans de paiement
- Nombre de plans validés

### Par plan de paiement
Dans les détails d'un plan, vous pouvez voir :
- Le montant total payé (premier apport)
- Le reste à payer
- L'avancement par échéance (à venir / payé / en retard)

## Conseils d'utilisation

### Organisation
1. Créez d'abord tous vos projets
2. Puis les ailes
3. Importez les lots en masse via CSV
4. Créez vos clients au fur et à mesure

### Plans de paiement
- Ne validez un plan que lorsque le client a accepté ET payé le premier apport
- Utilisez le mode automatique pour gagner du temps
- Le mode personnalisé permet plus de flexibilité (exemple : échéances plus importantes en début/fin)

### Sécurité
- Créez des comptes "Commercial" pour vos vendeurs
- Gardez le rôle "Administrateur" pour vous-même
- Les commerciaux peuvent créer des plans mais pas modifier les tarifs ou paramètres

### PDF
- Vérifiez toujours le profil agence avant de générer des PDF
- Les informations sont récupérées en temps réel
- Le PDF est professionnel et prêt à être envoyé au client

## Questions fréquentes

**Q: Puis-je modifier un plan validé ?**
R: Les montants sont gelés, mais vous pouvez modifier les dates des échéances restantes.

**Q: Le taux MAD peut-il être différent selon les plans ?**
R: Non, le taux est global. Modifiez-le dans les Réglages si nécessaire.

**Q: Puis-je supprimer un lot qui a des plans de paiement ?**
R: Non, le système l'empêche pour préserver l'historique.

**Q: Comment voir les plans d'un commercial spécifique ?**
R: Dans "Plans de paiement", la colonne "Créé par" indique le commercial.

**Q: Le parking doit-il toujours être sur une échéance spécifique ?**
R: Seulement en mode personnalisé. En mode automatique, il est réparti avec le reste.

## Support technique

En cas de problème :
1. Vérifiez la console du navigateur (F12)
2. Vérifiez que vous êtes bien connecté
3. Vérifiez que les variables d'environnement sont correctes
4. Vérifiez que toutes les migrations Supabase sont appliquées

Pour toute assistance : contact@shamsimmo.com
