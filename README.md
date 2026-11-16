# La Moula — v1.0.0

La paperasse des créatifs : devis, factures, clients et documents de production. Projet inspiré de l'architecture de La Caverne d'Alibaab : Electron pour Mac/Windows, PWA pour iPhone et GitHub Actions pour fabriquer les installateurs.

## Fonctionnalités de cette version

- Devis, factures, avoirs, notes de frais, contrats et bons de commande (documents génériques personnalisables).
- Numérotation automatique, lignes de prestations, quantités, prix HT, TVA par ligne et totaux HT/TVA/TTC.
- Carnet clients et coordonnées professionnelles.
- Export PDF via la boîte d'impression du navigateur ou de l'application (choisir « Enregistrer au format PDF »).
- Suivi payé / impayé des factures.
- Export/import de sauvegarde JSON.
- Mode local sans compte.
- Compte email/mot de passe et synchronisation cloud Supabase, avec isolation des données par utilisateur via RLS.
- PWA installable sur iPhone.
- Application Electron compilable pour Mac Apple Silicon/Intel et Windows x64.

## Lancer en local

Prérequis : Node.js 20+ et npm.

```bash
npm install
npm start
```

## Activer les comptes et la synchronisation

1. Créer un projet Supabase.
2. Dans Supabase > SQL Editor, exécuter le fichier `docs/SUPABASE.sql`.
3. Dans Supabase > Authentication > URL Configuration, renseigner l'URL de ton site GitHub Pages dans Site URL et Redirect URLs.
4. Copier l'URL du projet et la clé `anon` / `publishable` depuis Project Settings > API.
5. Les coller dans `src/public-config.js` :

```js
window.MOULA_PUBLIC_CONFIG = {
  supabaseUrl: 'https://TON-PROJET.supabase.co',
  supabaseAnonKey: 'sb_publishable_...'
};
```

6. Commit et push. Les visiteurs pourront créer un compte depuis l'application.

**Sécurité :** ne jamais utiliser la clé `service_role` ou une clé secrète dans le code. La clé publishable/anon est publique ; les politiques RLS du SQL sont indispensables. Chaque ligne est attachée à `auth.users.id` et un utilisateur ne peut lire/écrire que sa propre ligne.

Les comptes Supabase peuvent demander une confirmation par email selon les réglages Auth du projet. Pour les tests, désactiver la confirmation email est possible dans Supabase Auth, mais il est préférable de la conserver en production.

## Publier la version iPhone / web sur GitHub Pages

1. Créer un dépôt GitHub et y envoyer le contenu de ce dossier.
2. Dans Settings > Pages, choisir « GitHub Actions » comme source.
3. Dans Settings > Actions > General, autoriser les permissions nécessaires si GitHub le demande.
4. Pousser sur `main`. Le workflow `.github/workflows/pages.yml` publie le dossier `src`.
5. Ouvrir l'URL GitHub Pages sur iPhone dans Safari, toucher Partager puis « Sur l'écran d'accueil ».

La PWA utilise le service worker pour mettre en cache l'interface. La connexion et la synchronisation nécessitent Internet.

## Générer les applications Mac et Windows

Le workflow `.github/workflows/build.yml` construit les deux versions. Dans GitHub > Actions, lancer « Compiler La Moula pour Mac et Windows » avec « Run workflow », ou pousser un tag :

```bash
git tag v1.0.0
git push origin v1.0.0
```

Les installateurs sont joints à la Release GitHub. Le DMG n'est pas signé/notarisé : macOS peut afficher un avertissement à la première ouverture. Une distribution grand public sans avertissement demande un compte Apple Developer et la signature/notarisation. L'installateur Windows n'est pas signé non plus.

## Limites à connaître

- Les PDF sont générés par la fonction d'impression du système : choisir « Enregistrer au format PDF ».
- Les modèles de contrat, bon de commande et note de frais sont des bases vierges à adapter, pas des documents juridiques certifiés.
- La numérotation est automatique sur la base des documents présents sur l'appareil/compte ; pour une comptabilité réglementée multi-utilisateur, il faudra un service de numérotation transactionnel côté serveur.
- Cette version est un socle fonctionnel à tester avec les obligations propres à chaque statut. Les mentions légales, règles de TVA, délais de paiement, pénalités et mentions de franchise de TVA doivent être vérifiés selon la situation de l'entreprise. La Moula ne remplace pas un expert-comptable.
- Les données locales sont stockées dans le navigateur/appareil. Exporter régulièrement une sauvegarde. La synchronisation cloud ne fonctionne qu'après configuration de Supabase.

## GIF et icônes

Le GIF fourni est conservé comme logo animé dans l'interface. Les icônes PNG Mac/Windows/iPhone sont générées depuis sa première image, car les systèmes d'exploitation n'acceptent pas tous les GIF animés comme icône d'application.
