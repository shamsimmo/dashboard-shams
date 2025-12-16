# Guide de Synchronisation Bidirectionnelle HubSpot

Ce guide explique comment configurer la synchronisation bidirectionnelle entre votre dashboard SHAMS IMMO et HubSpot.

## Vue d'ensemble

La synchronisation bidirectionnelle permet :
- **HubSpot → Supabase** : Les contacts créés ou modifiés dans HubSpot sont automatiquement importés dans votre dashboard
- **Supabase → HubSpot** : Les modifications faites dans le dashboard sont automatiquement reflétées dans HubSpot

## Prérequis

1. Un compte HubSpot avec accès API
2. Votre clé API HubSpot configurée dans les paramètres du dashboard
3. Accès à la configuration des webhooks dans HubSpot

## Configuration du Webhook HubSpot → Supabase

### Étape 1 : Obtenir l'URL du Webhook

L'URL de votre webhook est :
```
https://[VOTRE_PROJET_SUPABASE_URL]/functions/v1/hubspot-webhook
```

Par exemple :
```
https://abcdefghijklmnop.supabase.co/functions/v1/hubspot-webhook
```

### Étape 2 : Configurer le Webhook dans HubSpot

1. Connectez-vous à votre compte HubSpot
2. Allez dans **Settings** (⚙️ en haut à droite)
3. Dans le menu de gauche, cliquez sur **Integrations** > **Private Apps**
4. Sélectionnez votre application privée ou créez-en une nouvelle
5. Dans l'onglet **Webhooks**, cliquez sur **Create subscription**

### Étape 3 : Configurer les Événements

Configurez les événements suivants pour une synchronisation complète :

#### Contact Creation (Création de contact)
- **Object type** : `Contact`
- **Event type** : `contact.creation`
- **Webhook URL** : Votre URL obtenue à l'étape 1

#### Contact Property Change (Modification de contact)
- **Object type** : `Contact`
- **Event type** : `contact.propertyChange`
- **Properties to monitor** :
  - `firstname`
  - `lastname`
  - `email`
  - `phone`
  - `mobilephone`

### Étape 4 : Valider la Configuration

1. Cliquez sur **Save** pour enregistrer votre webhook
2. HubSpot va tester la connexion en envoyant une requête test
3. Si tout est correct, le statut passera à "Active"

## Fonctionnement de la Synchronisation

### HubSpot → Supabase (Automatique)

Quand un contact est créé ou modifié dans HubSpot :
1. HubSpot envoie un webhook à votre Edge Function
2. L'Edge Function récupère les détails du contact depuis HubSpot
3. Le contact est créé ou mis à jour dans votre base Supabase
4. Le champ `hubspot_contact_id` est rempli pour maintenir le lien

### Supabase → HubSpot (Automatique)

Quand un contact est créé ou modifié dans le dashboard :
1. Un trigger de base de données ajoute la modification à une queue
2. La modification est envoyée à HubSpot via l'Edge Function `sync-to-hubspot`
3. Le contact est créé ou mis à jour dans HubSpot
4. Le champ `hubspot_contact_id` est rempli si c'est une création

## Désactiver la Synchronisation pour un Client

Si vous ne voulez pas qu'un client spécifique soit synchronisé avec HubSpot :

1. Dans le dashboard, allez dans **Contacts**
2. Modifiez le client concerné
3. Décochez l'option "Synchroniser avec HubSpot"
4. Sauvegardez

Le client ne sera plus synchronisé automatiquement, mais vous pourrez toujours le synchroniser manuellement si besoin.

## Synchronisation Manuelle

Pour synchroniser manuellement un client vers HubSpot :
1. Allez dans **Contacts**
2. Cliquez sur les trois points (⋮) à côté du client
3. Sélectionnez "Synchroniser avec HubSpot"

## Vérification de la Synchronisation

### Vérifier dans le Dashboard

Pour chaque client, vous pouvez voir :
- **ID HubSpot** : Si rempli, le client est lié à un contact HubSpot
- **Dernière synchro** : Date et heure de la dernière synchronisation
- **Statut** : Indique si la synchronisation est active

### Vérifier dans HubSpot

1. Allez dans **Contacts** dans HubSpot
2. Recherchez le contact par email ou nom
3. Les propriétés suivantes doivent être synchronisées :
   - Prénom
   - Nom
   - Email
   - Téléphone
   - Téléphone portable

## Résolution des Problèmes

### Le webhook ne fonctionne pas

1. Vérifiez que l'URL du webhook est correcte
2. Vérifiez que votre clé API HubSpot est configurée dans **Paramètres** > **Intégrations HubSpot**
3. Consultez les logs dans HubSpot : **Settings** > **Integrations** > **Private Apps** > Votre app > **Monitoring**

### Les modifications ne sont pas synchronisées

1. Vérifiez que le client a `sync_to_hubspot` = true
2. Vérifiez que la clé API HubSpot est valide
3. Consultez la table `hubspot_sync_queue` pour voir les erreurs :
   ```sql
   SELECT * FROM hubspot_sync_queue
   WHERE status = 'failed'
   ORDER BY created_at DESC;
   ```

### Boucles de synchronisation

Le système est conçu pour éviter les boucles infinies grâce au flag `is_syncing`. Si vous rencontrez des problèmes :

1. Vérifiez qu'aucun client n'est bloqué en état de synchronisation :
   ```sql
   SELECT * FROM clients WHERE is_syncing = true;
   ```

2. Si nécessaire, réinitialisez le flag :
   ```sql
   UPDATE clients SET is_syncing = false WHERE is_syncing = true;
   ```

## Maintenance

### Nettoyer la Queue de Synchronisation

Pour nettoyer les anciennes entrées de la queue (plus de 7 jours) :

```sql
SELECT cleanup_old_sync_queue();
```

Cette fonction peut être programmée pour s'exécuter automatiquement via un cron job.

## Support

Pour toute question ou problème, consultez :
- Les logs de l'Edge Function dans Supabase
- Les logs de webhook dans HubSpot
- La table `hubspot_sync_queue` pour les détails des synchronisations
