# Configuration Supabase — La Moula

Projet Supabase : **la moula**  
Référence : `pwvjybylbobqibvtpkiw`  
Région : `eu-west-1` (Europe)  
URL du projet : `https://pwvjybylbobqibvtpkiw.supabase.co`

> L'URL à mettre dans l'application est l'URL racine du projet. Ne pas ajouter `/rest/v1/`.

## 1. Configuration déjà effectuée

Le projet Supabase est déjà créé et actif. La table `public.moula_state` existe et la sécurité RLS est activée. Le contrôle de sécurité Supabase ne signale actuellement aucune alerte de sécurité.

Le fichier `src/public-config.js` de cette archive est déjà renseigné avec l'URL du projet et la clé publique `sb_publishable`. Cette clé est faite pour être utilisée dans le navigateur et dans les applications distribuées. Elle n'est pas une clé secrète. Ne jamais remplacer cette clé par une clé `secret_...` ou `service_role`.

## 2. SQL de la base de données

Le fichier `docs/SUPABASE.sql` contient le script complet de création/actualisation de la table et de ses politiques de sécurité.

La table stocke un document JSON par compte : devis, factures, clients et profil professionnel. La colonne `owner_id` correspond à l'identifiant du compte dans `auth.users`.

Pour (re)appliquer le script :

1. Ouvre le tableau de bord Supabase du projet `la moula`.
2. Ouvre **SQL Editor** puis **New query**.
3. Ouvre `docs/SUPABASE.sql` dans cette archive, copie tout son contenu et colle-le dans l'éditeur SQL.
4. Clique sur **Run**.

Le script est réexécutable : il ne supprime pas les données existantes. Il recrée seulement les quatre politiques RLS de La Moula.

## 3. Authentification par email

Dans Supabase, ouvre **Authentication > URL Configuration** :

- **Site URL** : l'adresse publique de La Moula sur GitHub Pages.
- **Redirect URLs** : ajoute également cette même adresse, ainsi que l'adresse locale si tu testes localement.

Exemple si ton dépôt s'appelle `la-moula` et que ton compte GitHub est `TON-PSEUDO` :

`https://TON-PSEUDO.github.io/la-moula/`

Remplace l'exemple par l'URL réelle de ton site. Ne copie pas cet exemple tel quel si ton dépôt ou ton pseudo est différent.

Dans **Authentication > Providers > Email**, vérifie que le fournisseur Email est activé. En production, garde de préférence la confirmation d'adresse email activée. Après inscription, l'utilisateur doit cliquer sur le lien reçu par email avant de pouvoir se connecter si cette option est activée.

## 4. Publier sur GitHub

1. Remplace les fichiers de ton dépôt par ceux de cette archive (ou au minimum `src/public-config.js` et `docs/SUPABASE.sql`).
2. Vérifie que le dossier `.github/workflows/` est bien présent à la racine du dépôt.
3. Envoie les changements sur la branche `main`.
4. Dans GitHub, ouvre **Settings > Pages** et sélectionne **GitHub Actions** comme source de déploiement.
5. Ouvre l'onglet **Actions** : le workflow `Publier La Moula pour iPhone et web` doit se lancer après le push. Tu peux aussi l'exécuter manuellement avec **Run workflow**.

## 5. Vérifier que les comptes fonctionnent

1. Ouvre le site GitHub Pages publié en HTTPS.
2. Ouvre **Ton compte La Moula**.
3. Crée un compte avec une adresse email et un mot de passe d'au moins 8 caractères.
4. Confirme l'adresse email si Supabase le demande.
5. Connecte-toi, crée un client puis un devis de test.
6. Recharge la page ou ouvre La Moula sur un autre appareil et reconnecte-toi : les données doivent réapparaître.

La synchronisation nécessite une connexion Internet. Le mode local reste disponible sans compte, mais les données locales d'un appareil ne sont pas automatiquement fusionnées avec le compte cloud.

## 6. Sécurité et limites

- La clé `sb_publishable` est publique et peut être intégrée au code client.
- Ne publie jamais une clé `secret_...`, `service_role` ou un mot de passe de base de données.
- RLS est activé sur `public.moula_state` ; les politiques comparent `owner_id` à `auth.uid()` pour chaque opération.
- La table n'accorde aucun accès au rôle `anon`.
- La synchronisation ne remplace pas une sauvegarde : utilise aussi l'export JSON de l'application.
- Ce système est une base de synchronisation de données applicatives, pas un logiciel de comptabilité certifié.
