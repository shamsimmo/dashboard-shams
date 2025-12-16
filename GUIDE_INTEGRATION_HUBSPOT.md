# Guide d'intégration HubSpot

## Vue d'ensemble

L'intégration HubSpot permet de synchroniser automatiquement vos contacts (clients et prospects) de SHAMS IMMO avec votre compte HubSpot CRM. Cette intégration facilite la gestion de vos relations clients et assure que vos données sont toujours à jour dans les deux systèmes.

## Configuration initiale

### 1. Créer une Private App dans HubSpot

1. Connectez-vous à votre compte HubSpot
2. Accédez à **Settings** (icône de roue dentée en haut à droite)
3. Dans le menu de gauche, allez dans **Integrations** → **Private Apps**
4. Cliquez sur **Create a private app**
5. Donnez un nom à votre application (ex: "SHAMS IMMO Integration")
6. Ajoutez une description (optionnel)

### 2. Configurer les permissions

Dans l'onglet **Scopes**, accordez les permissions suivantes :

**Contacts:**
- `crm.objects.contacts.read` (Lecture des contacts)
- `crm.objects.contacts.write` (Création et mise à jour des contacts)

**Deals (optionnel mais recommandé):**
- `crm.objects.deals.read` (Lecture des deals)
- `crm.objects.deals.write` (Création et mise à jour des deals)

### 3. Générer le token d'accès

1. Une fois les permissions configurées, cliquez sur **Create app**
2. HubSpot va générer un **Access Token**
3. **IMPORTANT:** Copiez ce token immédiatement, vous ne pourrez plus le voir après avoir fermé cette fenêtre
4. Conservez ce token en lieu sûr

### 4. Configurer l'intégration dans SHAMS IMMO

1. Connectez-vous à votre compte administrateur SHAMS IMMO
2. Accédez à **Réglages** dans le menu principal
3. Faites défiler jusqu'à la section **Intégration HubSpot**
4. Collez votre **HubSpot Private App Access Token** dans le champ prévu
5. (Optionnel) Configurez le **Pipeline** et le **Deal Stage** pour les deals
6. Activez l'intégration en basculant le bouton sur "ON"
7. Cliquez sur **Tester la connexion** pour vérifier que tout fonctionne
8. Cliquez sur **Enregistrer**

## Fonctionnalités

### Synchronisation automatique des contacts

Lorsque l'intégration est activée, les contacts sont automatiquement synchronisés avec HubSpot dans les situations suivantes :

#### À la création d'un nouveau client
- Un nouveau contact est créé dans HubSpot avec toutes les informations du client
- Les champs synchronisés : prénom, nom, email, téléphone, statut (prospect/client)

#### À la mise à jour d'un client existant
- Le contact existant dans HubSpot est mis à jour avec les nouvelles informations
- Si le contact n'existe pas encore dans HubSpot, il sera créé automatiquement

### Propriétés synchronisées

Les propriétés suivantes sont synchronisées avec HubSpot :

| Propriété SHAMS IMMO | Propriété HubSpot | Description |
|---------------------|-------------------|-------------|
| Email | `email` | Adresse email du contact |
| Prénom | `firstname` | Prénom du contact |
| Nom | `lastname` | Nom de famille du contact |
| Téléphone | `phone` | Numéro de téléphone |
| Statut | `status_client` | Prospect ou Client |
| Projet | `projet_lie` | Nom du projet associé |
| Lot | `lot_reference` | Référence du lot |

**Note:** Les propriétés personnalisées `status_client`, `projet_lie` et `lot_reference` doivent être créées manuellement dans HubSpot si vous souhaitez les utiliser.

### Création de propriétés personnalisées dans HubSpot

1. Dans HubSpot, allez dans **Settings** → **Properties**
2. Sélectionnez **Contact properties**
3. Cliquez sur **Create property**
4. Créez les propriétés suivantes :

**Propriété 1: Status Client**
- Label: `Status Client`
- Field type: `Dropdown select`
- Options: `prospect`, `client`
- Internal name: `status_client`

**Propriété 2: Projet lié**
- Label: `Projet lié`
- Field type: `Single-line text`
- Internal name: `projet_lie`

**Propriété 3: Lot référence**
- Label: `Lot référence`
- Field type: `Single-line text`
- Internal name: `lot_reference`

## Synchronisation des deals (optionnel)

L'intégration HubSpot permet également de créer des deals dans HubSpot pour suivre les opportunités commerciales. Cette fonctionnalité peut être étendue pour créer automatiquement un deal lorsqu'un plan de paiement est validé.

### Configuration des deals

Dans la section **Intégration HubSpot** des réglages :

1. **Pipeline** : Spécifiez le nom ou l'ID du pipeline HubSpot où les deals seront créés (par défaut: "default")
2. **Deal Stage** : Définissez le statut du deal lors de sa création (par défaut: "closedwon" pour une vente conclue)

### Utilisation programmatique

Pour créer un deal manuellement via le code :

```typescript
import { createDealInHubSpot } from '../utils/hubspot';

await createDealInHubSpot({
  dealname: 'Projet Example - Lot A1',
  amount: 150000,
  dealstage: 'closedwon',
  contact_email: 'client@example.com',
  project_name: 'Projet Example',
  lot_reference: 'A1',
});
```

## Sécurité

- Le token HubSpot est stocké de manière sécurisée côté backend
- Il n'est jamais exposé au frontend ou dans le code JavaScript du navigateur
- Tous les appels à l'API HubSpot sont effectués via une Edge Function sécurisée
- Une fois enregistré, le token est masqué dans l'interface (affiché comme "••••••••••")

## Dépannage

### Le test de connexion échoue

**Causes possibles:**
- Token invalide ou expiré
- Permissions insuffisantes dans HubSpot
- Problème de connectivité réseau

**Solutions:**
1. Vérifiez que le token a été copié correctement (sans espaces supplémentaires)
2. Assurez-vous que les permissions `crm.objects.contacts.read` et `crm.objects.contacts.write` sont accordées
3. Générez un nouveau token dans HubSpot si nécessaire

### Les contacts ne sont pas synchronisés

**Vérifications:**
1. L'intégration est-elle activée ? (bouton ON)
2. Le test de connexion réussit-il ?
3. Vérifiez la console du navigateur pour d'éventuelles erreurs
4. Consultez la date de "Dernière synchronisation" pour voir si des syncs ont eu lieu

### Erreur "Contact not found in HubSpot" lors de la création d'un deal

Le contact doit d'abord exister dans HubSpot avant de pouvoir créer un deal associé. Assurez-vous que :
1. Le contact a été créé dans SHAMS IMMO
2. La synchronisation automatique a été effectuée
3. L'email du contact est correct et correspond à celui dans HubSpot

## Limites et considérations

- La synchronisation est unidirectionnelle : SHAMS IMMO → HubSpot
- Les modifications faites dans HubSpot ne sont pas synchronisées vers SHAMS IMMO
- Les propriétés personnalisées doivent être créées manuellement dans HubSpot
- La synchronisation est effectuée en arrière-plan et ne bloque pas l'interface utilisateur
- En cas d'échec de la synchronisation, l'opération dans SHAMS IMMO continue normalement

## Support

Pour toute question ou problème avec l'intégration HubSpot, contactez votre administrateur système ou consultez la documentation HubSpot :
- [HubSpot Private Apps Documentation](https://developers.hubspot.com/docs/api/private-apps)
- [HubSpot CRM API Documentation](https://developers.hubspot.com/docs/api/crm/understanding-the-crm)

## Mises à jour futures

Les fonctionnalités suivantes pourraient être ajoutées dans les prochaines versions :
- Synchronisation bidirectionnelle
- Synchronisation des notes et activités
- Création automatique de deals lors de la validation d'un plan de paiement
- Webhooks pour recevoir les mises à jour de HubSpot
- Synchronisation des tâches et rappels
