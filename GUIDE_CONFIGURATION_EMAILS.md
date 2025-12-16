# Guide de Configuration des Templates d'Emails Supabase

## Vue d'ensemble

Ce guide explique comment configurer les templates d'emails professionnels dans Supabase pour votre application SHAMS IMMO. Les templates HTML complets sont disponibles dans le fichier `EMAIL_TEMPLATES.html`.

## Étapes d'installation

### 1. Accéder aux templates d'emails

1. Connectez-vous à votre [Dashboard Supabase](https://app.supabase.com)
2. Sélectionnez votre projet
3. Dans le menu latéral, allez dans **Authentication** > **Email Templates**

### 2. Configurer chaque template

Supabase propose 5 types de templates d'emails :

#### A. Reset Password (Réinitialisation de mot de passe)
**Quand il est envoyé :** Lorsqu'un utilisateur clique sur "Mot de passe oublié"

**Comment le configurer :**
1. Cliquez sur "Reset Password" dans la liste des templates
2. Copiez le code HTML du **TEMPLATE 1** depuis `EMAIL_TEMPLATES.html`
3. Collez-le dans l'éditeur
4. Remplacez `VOTRE-DOMAINE.COM` par votre vrai domaine
5. Cliquez sur "Save"

#### B. Confirm Signup (Confirmation d'inscription)
**Quand il est envoyé :** Lors de la création d'un nouveau collaborateur

**Comment le configurer :**
1. Cliquez sur "Confirm signup" dans la liste
2. Copiez le code HTML du **TEMPLATE 2** depuis `EMAIL_TEMPLATES.html`
3. Collez-le et remplacez le domaine
4. Cliquez sur "Save"

#### C. Invite User (Invitation)
**Quand il est envoyé :** Quand vous invitez un nouveau collaborateur

**Comment le configurer :**
1. Cliquez sur "Invite user"
2. Copiez le code HTML du **TEMPLATE 3** depuis `EMAIL_TEMPLATES.html`
3. Collez-le et remplacez le domaine
4. Cliquez sur "Save"

#### D. Magic Link (Connexion sans mot de passe)
**Quand il est envoyé :** Si vous activez la connexion par lien magique

**Comment le configurer :**
1. Cliquez sur "Magic Link"
2. Copiez le code HTML du **TEMPLATE 4** depuis `EMAIL_TEMPLATES.html`
3. Collez-le et remplacez le domaine
4. Cliquez sur "Save"

#### E. Change Email Address (Changement d'email)
**Quand il est envoyé :** Quand un utilisateur change son adresse email

**Comment le configurer :**
1. Cliquez sur "Change Email Address"
2. Copiez le code HTML du **TEMPLATE 5** depuis `EMAIL_TEMPLATES.html`
3. Collez-le et remplacez le domaine
4. Cliquez sur "Save"

### 3. Personnaliser le logo

Par défaut, les templates utilisent cette URL pour le logo :
```
https://VOTRE-DOMAINE.COM/logo.png
```

**Options :**

**Option A - Utiliser votre domaine :**
1. Uploadez votre logo sur votre hébergement
2. Remplacez `VOTRE-DOMAINE.COM` par votre vrai domaine dans tous les templates

**Option B - Utiliser Supabase Storage :**
1. Allez dans **Storage** dans le dashboard Supabase
2. Créez un bucket public appelé "assets"
3. Uploadez votre logo
4. Obtenez l'URL publique du logo
5. Remplacez l'URL du logo dans tous les templates par cette URL

**Option C - Utiliser un CDN externe :**
1. Uploadez votre logo sur un service comme Cloudinary, ImgBB, ou AWS S3
2. Obtenez l'URL publique
3. Remplacez l'URL du logo dans tous les templates

### 4. Configurer les URLs de redirection

#### Pour Reset Password :
1. Allez dans **Authentication** > **URL Configuration**
2. Dans "Site URL", entrez : `https://votre-domaine.com`
3. Dans "Redirect URLs", ajoutez :
   - `https://votre-domaine.com/reset-password`
   - `http://localhost:5173/reset-password` (pour le développement)

#### Pour les autres templates :
Les URLs sont automatiquement gérées par Supabase avec la variable `{{ .ConfirmationURL }}`.

### 5. Tester les emails

#### Test en développement :

1. **Pour Reset Password :**
   - Allez sur votre page de connexion
   - Cliquez sur "Mot de passe oublié ?"
   - Entrez un email de test
   - Vérifiez la console Supabase ou votre boîte email

2. **Pour Confirm Signup :**
   - Créez un nouveau collaborateur via la page Collaborateurs
   - Vérifiez l'email envoyé

3. **Vérifier dans Supabase :**
   - Allez dans **Authentication** > **Users**
   - Les emails envoyés apparaissent dans les logs

#### Activer les emails en local (développement) :

Par défaut, Supabase n'envoie pas d'emails en développement. Pour tester :

1. Allez dans **Project Settings** > **Auth**
2. Désactivez "Enable email confirmations" temporairement
3. Ou configurez un serveur SMTP personnalisé (voir section suivante)

### 6. Configuration SMTP (Optionnel mais recommandé)

Pour utiliser votre propre serveur email (Gmail, SendGrid, Mailgun, etc.) :

1. Allez dans **Project Settings** > **Auth**
2. Faites défiler jusqu'à "SMTP Settings"
3. Activez "Enable Custom SMTP"
4. Entrez vos informations SMTP :

**Exemple avec Gmail :**
```
Host: smtp.gmail.com
Port: 587
Username: votre-email@gmail.com
Password: votre-mot-de-passe-app
Sender email: votre-email@gmail.com
Sender name: SHAMS IMMO
```

**Exemple avec SendGrid :**
```
Host: smtp.sendgrid.net
Port: 587
Username: apikey
Password: VOTRE_SENDGRID_API_KEY
Sender email: noreply@votre-domaine.com
Sender name: SHAMS IMMO
```

### 7. Personnaliser les textes

Vous pouvez personnaliser les textes dans chaque template HTML :

1. Ouvrez le fichier `EMAIL_TEMPLATES.html`
2. Cherchez les textes que vous voulez modifier
3. Changez-les directement dans le HTML
4. Copiez-collez le template modifié dans Supabase

**Textes courants à personnaliser :**
- Nom de l'entreprise : "SHAMS IMMO"
- Messages de bienvenue
- Mentions légales dans le footer
- Durée de validité des liens

### 8. Variables Supabase disponibles

Dans vos templates, vous pouvez utiliser ces variables :

- `{{ .ConfirmationURL }}` - Lien de confirmation/réinitialisation
- `{{ .Token }}` - Token de confirmation (rarement utilisé)
- `{{ .TokenHash }}` - Hash du token (rarement utilisé)
- `{{ .SiteURL }}` - URL de votre site
- `{{ .Email }}` - Email de l'utilisateur

**Exemple d'utilisation :**
```html
<p>Votre email : {{ .Email }}</p>
<a href="{{ .ConfirmationURL }}">Confirmer</a>
```

## Résolution de problèmes

### Les emails ne sont pas envoyés

**Vérifications :**
1. Les emails de confirmation sont-ils activés dans Auth settings ?
2. Le domaine est-il correctement configuré ?
3. Vérifiez les logs dans **Authentication** > **Logs**
4. L'email existe-t-il dans **Authentication** > **Users** ?

### Les liens ne fonctionnent pas

**Solutions :**
1. Vérifiez que la "Site URL" est correcte dans les paramètres
2. Vérifiez que `/reset-password` est bien dans les "Redirect URLs"
3. Testez le lien manuellement en le copiant-collant

### Les emails arrivent en spam

**Solutions :**
1. Configurez un serveur SMTP personnalisé
2. Ajoutez des enregistrements SPF et DKIM à votre domaine
3. Utilisez un service email professionnel (SendGrid, Mailgun)
4. Évitez les mots spam dans vos templates

### Le logo ne s'affiche pas

**Solutions :**
1. Vérifiez que l'URL du logo est publiquement accessible
2. Testez l'URL dans un navigateur
3. Vérifiez que le bucket Supabase Storage est public (si utilisé)
4. Vérifiez qu'il n'y a pas de CORS qui bloque l'image

## Bonnes pratiques

1. **Testez toujours vos templates** avant de les mettre en production
2. **Gardez une copie de sauvegarde** de vos templates personnalisés
3. **Utilisez un SMTP personnalisé** pour une meilleure délivrabilité
4. **Surveillez les taux d'ouverture** des emails
5. **Mettez à jour régulièrement** les informations de contact
6. **Restez cohérent** avec votre identité visuelle

## Support

Pour plus d'informations :
- [Documentation Supabase Auth](https://supabase.com/docs/guides/auth)
- [Email Templates Documentation](https://supabase.com/docs/guides/auth/auth-email-templates)
- [SMTP Configuration Guide](https://supabase.com/docs/guides/auth/auth-smtp)

## Checklist finale

- [ ] Tous les templates sont configurés
- [ ] Les URLs sont correctement remplacées
- [ ] Le logo s'affiche correctement
- [ ] Les redirections fonctionnent
- [ ] Les emails de test sont reçus
- [ ] Les liens fonctionnent correctement
- [ ] La configuration SMTP est validée (si utilisée)
- [ ] Les textes sont personnalisés selon vos besoins
