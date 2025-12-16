# Guide de Synchronisation Bidirectionnelle HubSpot ↔ Dashboard

## Vue d'ensemble

La synchronisation bidirectionnelle entre HubSpot et votre dashboard est maintenant entièrement opérationnelle avec la règle suivante :

**La dernière modification gagne toujours**, qu'elle provienne de HubSpot ou du dashboard.

---

## Principe de fonctionnement

### 1. Champs de référence pour les dates

#### Dans Supabase (table `clients`)
- `updated_at` : date/heure de dernière modification locale (dashboard)
- `hubspot_last_modified_date` : date/heure de dernière modification côté HubSpot
- `hubspot_created_at` : date de création dans HubSpot

#### Dans HubSpot (contact)
- `lastmodifieddate` : date/heure de dernière modification côté HubSpot
- `createdate` : date de création du contact

### 2. Règle de décision

Pour chaque contact/prospect, le système :

1. **Récupère les deux dates** :
   - `updated_at` (Supabase)
   - `lastmodifieddate` (HubSpot)

2. **Compare les dates** :
   - Si `updated_at > lastmodifieddate` → La version **dashboard** est plus récente → **Mise à jour HubSpot**
   - Si `lastmodifieddate > updated_at` → La version **HubSpot** est plus récente → **Mise à jour Supabase**
   - Si égales → Aucune mise à jour nécessaire

3. **Après la synchronisation** :
   - Met à jour `hubspot_last_modified_date` dans Supabase
   - Trace la synchronisation dans les logs

---

## Composants de la synchronisation

### 1. Edge Function : `hubspot-bidirectional-sync`

**Rôle** : Fonction principale qui implémente la logique de comparaison des dates

**URL** : `${SUPABASE_URL}/functions/v1/hubspot-bidirectional-sync`

**Paramètres** :
```json
{
  "client_id": "uuid",
  "email": "email@example.com",
  "hubspot_contact_id": "123456"
}
```

**Logique** :
1. Charge le client depuis Supabase
2. Charge le contact depuis HubSpot (par ID ou email)
3. Compare les dates de modification
4. Décide de l'action à effectuer :
   - `create_hubspot` : Créer le contact dans HubSpot
   - `update_hubspot` : Mettre à jour HubSpot avec les données Supabase
   - `update_supabase` : Mettre à jour Supabase avec les données HubSpot
   - `no_action` : Les deux versions sont à jour

**Réponse** :
```json
{
  "success": true,
  "action": "update_hubspot",
  "client_id": "uuid",
  "hubspot_contact_id": "123456"
}
```

### 2. Edge Function : `sync-to-hubspot`

**Rôle** : Point d'entrée simplifié qui appelle `hubspot-bidirectional-sync`

**URL** : `${SUPABASE_URL}/functions/v1/sync-to-hubspot`

**Utilisation** : Appelée depuis le dashboard lors des modifications

### 3. Edge Function : `hubspot-webhook`

**Rôle** : Reçoit les notifications de HubSpot lors des modifications

**Logique** :
1. Reçoit l'événement HubSpot (création, modification)
2. Récupère les détails du contact depuis HubSpot
3. Compare avec la version Supabase
4. Ne met à jour Supabase que si HubSpot est plus récent

### 4. Service de synchronisation automatique (Cron)

**Fichier** : `services/hubspotProspectsSyncService.js`

**Fréquence** : Toutes les 5 minutes

**Logique** :
1. Récupère les leads HubSpot modifiés depuis la dernière sync
2. Pour chaque lead :
   - Charge la version locale (prospect/client)
   - Compare les dates
   - Applique la règle "dernière modification gagnante"
   - Met à jour uniquement si nécessaire

---

## Scénarios de synchronisation

### Scénario 1 : Modification dans le dashboard

1. **Utilisateur modifie un client** dans la page Contacts
2. **Données sauvegardées** dans Supabase
   - `updated_at` = maintenant
3. **Synchronisation automatique** vers HubSpot :
   - Appel à `syncClientToHubSpotBidirectional()`
   - Appel à Edge Function `sync-to-hubspot`
   - Appel à Edge Function `hubspot-bidirectional-sync`
   - Comparaison des dates
   - Mise à jour HubSpot car Supabase est plus récent
4. **Résultat** : HubSpot est mis à jour avec les données du dashboard

### Scénario 2 : Modification dans HubSpot

1. **Utilisateur modifie un contact** dans HubSpot
2. **Webhook déclenché** :
   - HubSpot envoie un événement à `hubspot-webhook`
3. **Traitement du webhook** :
   - Récupération des détails du contact depuis HubSpot
   - Comparaison avec la version Supabase
   - Si HubSpot plus récent → Mise à jour Supabase
   - Sinon → Pas de mise à jour
4. **Résultat** : Supabase est mis à jour si HubSpot était plus récent

### Scénario 3 : Synchronisation automatique (Cron)

1. **Service cron s'exécute** toutes les 5 minutes
2. **Pour chaque lead HubSpot** :
   - Récupère `lastmodifieddate` de HubSpot
   - Récupère `updated_at` de Supabase
   - Compare les dates
   - Met à jour uniquement si HubSpot plus récent
3. **Résultat** : Les modifications HubSpot sont importées si elles sont plus récentes

### Scénario 4 : Synchronisation manuelle

1. **Utilisateur clique sur "Re-synchroniser"** (si disponible)
2. **Appel à** `hubspot-bidirectional-sync`
3. **Comparaison et mise à jour** selon la règle
4. **Résultat** : La version la plus récente gagne

---

## Éviter les boucles infinies

Le système est conçu pour éviter les boucles infinies de synchronisation :

1. **Pas de mise à jour si égalité** : Si les dates sont identiques, aucune mise à jour n'est effectuée
2. **Mise à jour de `hubspot_last_modified_date`** : Permet de tracker la dernière date connue de HubSpot
3. **Comparaison stricte** : Utilise `>` (supérieur strict) pour éviter les mises à jour répétitives
4. **Pas de trigger automatique** : Le trigger Supabase n'ajoute à la queue que si nécessaire

---

## Configuration requise

### Dans Supabase

1. **Tables** :
   - `clients` avec les champs :
     - `updated_at`
     - `hubspot_contact_id`
     - `hubspot_created_at`
     - `hubspot_last_modified_date`
   - `prospects` (optionnel, même structure)
   - `hubspot_settings` avec :
     - `api_key` : Clé API HubSpot

2. **Edge Functions déployées** :
   - `hubspot-bidirectional-sync`
   - `sync-to-hubspot`
   - `hubspot-webhook`

### Dans HubSpot

1. **Webhook configuré** :
   - URL : `${SUPABASE_URL}/functions/v1/hubspot-webhook`
   - Événements : `contact.creation`, `contact.propertyChange`

2. **Propriétés du contact** :
   - `firstname`
   - `lastname`
   - `email`
   - `phone`
   - `mobilephone`
   - `lastmodifieddate`

### Service de synchronisation automatique

1. **Variables d'environnement** (`.env`) :
   ```
   SUPABASE_URL=votre_url
   SUPABASE_SERVICE_KEY=votre_cle_service
   HUBSPOT_ACCESS_TOKEN=votre_token_hubspot
   ```

2. **Lancement du service** :
   ```bash
   cd services
   npm install
   node hubspotProspectsSyncService.js
   ```

---

## Tests et vérification

### Test 1 : Modification Dashboard → HubSpot

1. Modifiez un client dans le dashboard (Contacts)
2. Cliquez sur "Enregistrer"
3. Vérifiez dans HubSpot que le contact a été mis à jour
4. Vérifiez les logs de la console pour confirmer la synchronisation

### Test 2 : Modification HubSpot → Dashboard

1. Modifiez un contact dans HubSpot
2. Attendez quelques secondes (webhook)
3. Actualisez le dashboard
4. Vérifiez que les modifications apparaissent dans le dashboard

### Test 3 : Synchronisation automatique

1. Créez un nouveau lead dans HubSpot (lifecycle stage = "lead")
2. Attendez 5 minutes maximum
3. Vérifiez que le prospect apparaît dans la table `prospects`

### Test 4 : Conflit de modification

1. Modifiez un champ côté dashboard (ex: prénom)
2. Sans synchroniser, modifiez le même contact dans HubSpot
3. Déclenchez la synchronisation
4. **Résultat attendu** : La dernière modification (en temps) doit gagner

---

## Logs et débogage

### Logs Dashboard (Console navigateur)

```javascript
// Lors d'une mise à jour
"Client synchronisé avec HubSpot"

// En cas d'erreur
"HubSpot sync error: [message d'erreur]"
```

### Logs Edge Functions (Supabase Dashboard)

```
Comparison: {
  supabase_updated_at: "2025-12-11T10:30:00Z",
  hubspot_last_modified: "2025-12-11T10:25:00Z"
}
Action: update_hubspot
```

### Logs Service Cron

```
🚀 Starting HubSpot Leads Sync
📥 Retrieved 15 leads from HubSpot
   Comparing dates for john@example.com:
     - Supabase: 2025-12-11T10:30:00Z
     - HubSpot:  2025-12-11T10:25:00Z
   ⏭️  Skipping update - Supabase version is newer or equal
✅ Sync completed
```

---

## Avantages de cette implémentation

1. **Aucune perte de données** : La dernière modification est toujours préservée
2. **Synchronisation en temps réel** : Modifications immédiatement propagées
3. **Pas de conflit** : Résolution automatique basée sur les timestamps
4. **Transparent** : Utilisateurs n'ont pas besoin de se soucier de la synchronisation
5. **Robuste** : Évite les boucles infinies et les mises à jour inutiles
6. **Traçable** : Tous les événements sont loggés

---

## Support et maintenance

Pour toute question ou problème :

1. Vérifiez les logs dans la console du navigateur
2. Vérifiez les logs des Edge Functions dans Supabase
3. Vérifiez les logs du service cron
4. Assurez-vous que le webhook HubSpot est correctement configuré
5. Vérifiez que la clé API HubSpot est valide

---

## Conclusion

La synchronisation bidirectionnelle est maintenant entièrement opérationnelle et suit la règle simple : **la dernière modification gagne, toujours**.

Vous pouvez modifier vos contacts dans le dashboard ou dans HubSpot en toute confiance, le système se charge de maintenir les deux en synchronisation.
