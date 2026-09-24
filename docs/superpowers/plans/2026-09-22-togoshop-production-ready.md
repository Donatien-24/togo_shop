# TogoShop Production-Ready Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Porter TogoShop à un niveau production-ready, testé et accessible sur Android, iOS, Web, Windows, macOS et Linux, avec une CI multiplateforme et une documentation complète.

**Architecture:** Conserver l’architecture actuelle par couches (`models`, `repositories`, `providers`, `screens`, `widgets`) et Riverpod. Renforcer les frontières d’injection pour rendre le repository, les préférences et les providers testables; ajouter l’internationalisation Flutter officielle et un chargement d’images mis en cache sans réécrire inutilement l’application.

**Tech Stack:** Flutter/Dart SDK `^3.12.2`, Material 3, `flutter_riverpod`, `shared_preferences`, `flutter_localizations`, `intl`, cache d’images, `flutter_test`, `integration_test`, GitHub Actions.

## Global Constraints

- Support fonctionnel: Android, iOS, Web, Windows, macOS et Linux.
- Interface disponible au minimum en français et en anglais.
- Minimum de 10 tests unitaires, 5 tests de widgets et 2 tests d’intégration.
- `flutter analyze` doit terminer sans erreur ni warning.
- Les images doivent être chargées paresseusement, mises en cache et afficher un état de chargement ou d’erreur.
- Les contrôles interactifs doivent exposer un nom sémantique exploitable par lecteur d’écran.
- La CI doit exécuter lint, tests et builds adaptés à chaque plateforme.
- Ne pas remplacer Riverpod par un autre gestionnaire d’état.
- Ne pas stocker de secrets dans le dépôt.
- Ne pas promettre une IPA signée sans certificat Apple; produire au minimum une build iOS non signée sur runner macOS.
- Préserver les changements utilisateur existants et vérifier `git status` avant chaque commit.

---

## État initial vérifié

- L’application possède déjà les parcours catalogue, détail produit, favoris, panier et profil.
- Riverpod est déjà utilisé pour les produits, filtres, panier, favoris, profil et thème.
- Les produits sont chargés depuis `assets/data/products.json`.
- `flutter analyze` échoue actuellement uniquement dans `test/widget_test.dart`.
- `flutter test` échoue actuellement parce que ce test contient encore `MyApp`, un ancien smoke test et une structure Dart invalide.
- Aucun dossier `.github/workflows/` n’existe encore.
- Le `README.md` contient encore du texte de projet Flutter généré et ne documente pas encore la CI, l’i18n, les captures ni les builds multiplateformes.

## Inventaire des fichiers

### Fichiers à modifier

- `pubspec.yaml`: dépendances i18n, cache d’images et tests d’intégration; déclaration éventuelle des assets de localisation.
- `analysis_options.yaml`: règles de qualité supplémentaires compatibles avec Flutter Lints.
- `lib/main.dart`: initialisation de la locale, thème et dépendances injectées.
- `lib/screens/main_screen.dart`: navigation accessible et responsive.
- `lib/screens/home_screen.dart`: catalogue paresseux et états d’écran.
- `lib/screens/product_detail_screen.dart`: image cacheable, labels sémantiques et textes localisés.
- `lib/screens/cart_screen.dart`: états vide, actions accessibles et textes localisés.
- `lib/screens/favorites_screen.dart`: états vide, actions accessibles et textes localisés.
- `lib/screens/profile_screen.dart`: sélecteurs de langue et de thème.
- `lib/widgets/catalog_toolbar.dart`: recherche, filtre, tri et labels accessibles.
- `lib/widgets/product_card.dart`: carte constante autant que possible, image optimisée et semantics.
- `lib/widgets/cart_item_tile.dart`: boutons de quantité accessibles.
- `lib/providers/*.dart`: injection des dépendances et extraction des calculs testables si nécessaire.
- `lib/repositories/product_repository.dart`: validation JSON, cache mémoire et erreurs explicites.
- `README.md`: documentation de production.
- `pubspec.lock`: mise à jour via `flutter pub get`, sans édition manuelle.

### Fichiers à créer

- `lib/l10n/app_fr.arb`: traductions françaises.
- `lib/l10n/app_en.arb`: traductions anglaises.
- `lib/core/l10n/locale_provider.dart`: locale choisie et persistance.
- `lib/widgets/cached_product_image.dart`: composant d’image partagé.
- `test/helpers/test_data.dart`: produits et préférences de test déterministes.
- `test/models/product_test.dart`.
- `test/models/cart_item_test.dart`.
- `test/providers/cart_provider_test.dart`.
- `test/providers/favorites_provider_test.dart`.
- `test/providers/filter_provider_test.dart`.
- `test/providers/profile_provider_test.dart`.
- `test/providers/products_provider_test.dart`.
- `test/repositories/product_repository_test.dart`.
- `test/core/formatters_test.dart`.
- `test/widgets/navigation_test.dart`.
- `test/widgets/catalog_test.dart`.
- `test/widgets/catalog_toolbar_test.dart`.
- `test/widgets/product_card_test.dart`.
- `test/widgets/cart_item_tile_test.dart`.
- `integration_test/app_test.dart`.
- `.github/workflows/ci.yml`.
- `.github/workflows/release.yml`.
- `CHANGELOG.md`.
- `docs/screenshots/README.md`.
- `docs/architecture.md`.

---

## Task 1: Réparer le socle de tests et établir le baseline

**Files:**
- Modify: `test/widget_test.dart`
- Create: `test/helpers/test_data.dart`
- Test: `test/widget_test.dart`

- [ ] Remplacer le smoke test `MyApp` par un test qui instancie `TogoShopApp` dans un `ProviderScope`.
- [ ] Ajouter un helper de préférences:

```dart
Future<SharedPreferences> buildTestPreferences([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}
```

- [ ] Ajouter une factory `sampleProduct` avec un produit en stock, un produit hors stock et des prix distincts.
- [ ] Injecter le repository et les préférences au lieu de dépendre d’un état global non contrôlé.
- [ ] Vérifier le baseline:

```powershell
flutter analyze
flutter test
```

**Résultat attendu:** les tests existants compilent et la suite termine sans échec avant d’ajouter de nouvelles fonctionnalités.

---

## Task 2: Stabiliser les modèles, le repository et les providers

**Files:**
- Modify: `lib/repositories/product_repository.dart`
- Modify: `lib/providers/cart_provider.dart`
- Modify: `lib/providers/favorites_provider.dart`
- Modify: `lib/providers/filter_provider.dart`
- Modify: `lib/providers/products_provider.dart`
- Modify: `lib/providers/profile_provider.dart`
- Modify: `lib/models/product.dart`
- Modify: `lib/models/cart_item.dart`
- Create: `test/models/product_test.dart`
- Create: `test/models/cart_item_test.dart`
- Create: `test/providers/cart_provider_test.dart`
- Create: `test/providers/favorites_provider_test.dart`
- Create: `test/providers/filter_provider_test.dart`
- Create: `test/providers/profile_provider_test.dart`
- Create: `test/providers/products_provider_test.dart`
- Create: `test/repositories/product_repository_test.dart`
- Create: `test/core/formatters_test.dart`

- [ ] Écrire les tests unitaires avant chaque correction métier.
- [ ] Couvrir au minimum:
  - désérialisation d’un produit valide;
  - rejet ou erreur explicite d’un JSON incomplet;
  - ajout au panier;
  - fusion d’un même produit;
  - respect du stock maximum;
  - incrémentation, décrémentation, suppression et vidage;
  - sous-total et quantité totale;
  - ajout/retrait/persistance des favoris;
  - recherche, catégorie et tri;
  - profil et thème persistés;
  - chargement produit réussi et erreur de chargement.
- [ ] Ajouter un cache mémoire au repository pour éviter de relire et parser le JSON à chaque `findById`.
- [ ] Garder les opérations de provider synchrones quand elles sont purement en mémoire et async uniquement pour la persistance.
- [ ] Vérifier les bornes `stock <= 0`, quantité négative, identifiant inconnu et liste vide.
- [ ] Exécuter les tests ciblés après chaque provider:

```powershell
flutter test test/models test/providers test/repositories test/core
```

**Résultat attendu:** au moins 10 tests unitaires utiles, indépendants de l’interface et déterministes.

---

## Task 3: Ajouter l’internationalisation FR/EN

**Files:**
- Modify: `pubspec.yaml`
- Modify: `lib/main.dart`
- Create: `lib/l10n/app_fr.arb`
- Create: `lib/l10n/app_en.arb`
- Create: `lib/core/l10n/locale_provider.dart`
- Modify: `lib/core/constants/app_strings.dart`
- Modify: `lib/screens/*.dart`
- Modify: `lib/widgets/*.dart`
- Create: `test/core/locale_provider_test.dart`

- [ ] Ajouter `flutter_localizations` dans les dépendances Flutter SDK et `intl` dans les dépendances publiques.
- [ ] Déclarer les localisations dans `MaterialApp` avec `localizationsDelegates`, `supportedLocales` et `locale` provenant du provider.
- [ ] Définir les clés ARB pour les titres, actions, erreurs, états vides, catégories, unités et messages de panier/favoris.
- [ ] Remplacer les chaînes françaises codées en dur par `AppLocalizations.of(context)!`.
- [ ] Préserver la locale système par défaut et persister le choix explicite FR/EN via `SharedPreferences`.
- [ ] Ajouter un contrôle de langue dans le profil avec les labels `Français` et `English`.
- [ ] Tester que la locale change le titre, la navigation et au moins une action métier.

```powershell
flutter gen-l10n
flutter analyze
flutter test test/core/locale_provider_test.dart
```

**Résultat attendu:** aucun texte utilisateur important ne dépend d’une langue codée en dur et l’app démarre en FR ou EN selon le choix de l’utilisateur.

---

## Task 4: Optimiser les images et le rendu catalogue

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/widgets/cached_product_image.dart`
- Modify: `lib/widgets/product_card.dart`
- Modify: `lib/widgets/catalog_toolbar.dart`
- Modify: `lib/screens/home_screen.dart`
- Modify: `lib/screens/product_detail_screen.dart`
- Create: `test/widgets/catalog_test.dart`
- Create: `test/widgets/product_card_test.dart`

- [ ] Ajouter une dépendance de cache d’images stable compatible avec les plateformes supportées.
- [ ] Centraliser l’affichage dans `CachedProductImage` avec:
  - taille/ratio déterministes;
  - placeholder léger;
  - gestion d’erreur avec icône et label sémantique;
  - `cacheWidth` lorsque la taille d’affichage est connue;
  - support des contraintes desktop et mobile.
- [ ] Utiliser `GridView.builder` ou `ListView.builder` afin de ne construire que les cartes visibles.
- [ ] Éviter les `watch` Riverpod trop larges dans les cartes; écouter uniquement l’état favori ou panier nécessaire.
- [ ] Ajouter des clés stables `ValueKey(product.id)` aux éléments de liste.
- [ ] Vérifier qu’un catalogue long ne construit pas tous les produits en mémoire à l’ouverture.
- [ ] Tester le rendu normal et le fallback d’image avec `errorBuilder` ou un mock de réseau.

```powershell
flutter test test/widgets/catalog_test.dart test/widgets/product_card_test.dart
flutter run --profile -d chrome
```

**Résultat attendu:** défilement fluide, chargement progressif et absence de layout overflow sur mobile, tablette et desktop.

---

## Task 5: Renforcer l’accessibilité et le responsive design

**Files:**
- Modify: `lib/screens/main_screen.dart`
- Modify: `lib/screens/home_screen.dart`
- Modify: `lib/screens/product_detail_screen.dart`
- Modify: `lib/screens/cart_screen.dart`
- Modify: `lib/screens/favorites_screen.dart`
- Modify: `lib/screens/profile_screen.dart`
- Modify: `lib/widgets/catalog_toolbar.dart`
- Modify: `lib/widgets/product_card.dart`
- Modify: `lib/widgets/cart_item_tile.dart`
- Create: `test/widgets/navigation_test.dart`
- Create: `test/widgets/catalog_toolbar_test.dart`
- Create: `test/widgets/cart_item_tile_test.dart`

- [ ] Ajouter `Semantics(label: ..., button: true)` aux actions sans texte explicite.
- [ ] Donner un label descriptif aux images produit, boutons favori, ajout panier, suppression et quantité.
- [ ] Vérifier les destinations de navigation avec des labels traduits.
- [ ] Utiliser `Expanded`, `Flexible`, `Wrap`, `ConstrainedBox` et des grilles adaptatives plutôt que des largeurs fixes.
- [ ] Ajouter des états vides explicites pour catalogue, favoris et panier.
- [ ] Tester au minimum les tailles 360x800, 768x1024 et 1440x900 avec `MediaQuery` contrôlé.
- [ ] Tester la navigation clavier sur Web/Desktop et les boutons via `find.bySemanticsLabel`.

```powershell
flutter test test/widgets
flutter run -d windows
flutter run -d chrome
```

**Résultat attendu:** les parcours principaux sont utilisables au clavier, avec lecteur d’écran et sur les six plateformes ciblées.

---

## Task 6: Compléter les tests d’intégration

**Files:**
- Modify: `pubspec.yaml`
- Create: `integration_test/app_test.dart`
- Modify: `lib/screens/*.dart` uniquement si un parcours échoue

- [ ] Ajouter `integration_test` comme dépendance SDK de développement.
- [ ] Écrire le parcours catalogue vers panier:
  1. démarrer l’application;
  2. attendre la fin du chargement;
  3. ouvrir un produit;
  4. l’ajouter au panier;
  5. ouvrir le panier;
  6. modifier la quantité;
  7. vérifier le total.
- [ ] Écrire le parcours favoris/profil:
  1. ouvrir un produit;
  2. l’ajouter aux favoris;
  3. changer la langue;
  4. changer le thème;
  5. redémarrer le widget;
  6. vérifier la persistance.
- [ ] Donner à chaque action un `Key` ou un label stable pour éviter les sélecteurs fragiles.
- [ ] Exécuter les intégrations sur Android ou Chrome:

```powershell
flutter test integration_test/app_test.dart -d chrome
```

**Résultat attendu:** au moins 2 tests d’intégration reproduisant des usages réels plutôt que des détails d’implémentation.

---

## Task 7: Ajouter la CI GitHub Actions multiplateforme

**Files:**
- Create: `.github/workflows/ci.yml`
- Create: `.github/workflows/release.yml`

- [ ] Créer un job Linux pour `flutter analyze`, tests unitaires/widgets, tests d’intégration Web et build Web.
- [ ] Créer un job Windows pour analyse, tests et `flutter build windows`.
- [ ] Créer un job macOS pour analyse, tests, `flutter build macos` et `flutter build ios --no-codesign`.
- [ ] Créer un job Android sur Ubuntu pour `flutter build apk --debug` et `flutter build apk --release` si les fichiers Android sont valides.
- [ ] Créer un job Linux desktop pour `flutter build linux` si les dépendances système du runner sont disponibles.
- [ ] Utiliser une version Flutter explicitement fixée et le cache pub/Gradle.
- [ ] Publier les builds dans `actions/upload-artifact` avec des noms distincts.
- [ ] Faire échouer la CI si analyse ou tests échouent.
- [ ] Ajouter un workflow de release déclenché par tag `v*` qui publie les artefacts non signés.

Commandes locales équivalentes:

```powershell
flutter analyze
flutter test
flutter build apk --debug
flutter build web
```

**Résultat attendu:** chaque plateforme a un job explicite, et la CI ne masque jamais une erreur d’analyse ou de test.

---

## Task 8: Finaliser le README, le changelog et les captures

**Files:**
- Modify: `README.md`
- Create: `CHANGELOG.md`
- Create: `docs/architecture.md`
- Create: `docs/screenshots/README.md`
- Create: `docs/screenshots/catalog.png`
- Create: `docs/screenshots/product-detail.png`
- Create: `docs/screenshots/cart.png`
- Create: `docs/screenshots/profile.png`

- [ ] Réécrire le README avec:
  - description produit;
  - badges CI, plateforme et licence;
  - captures avec texte alternatif;
  - fonctionnalités;
  - architecture et flux de données;
  - prérequis;
  - installation;
  - commandes de test/analyse/build;
  - tableau des plateformes supportées;
  - limites de signature iOS et publication.
- [ ] Documenter l’architecture dans `docs/architecture.md` avec les responsabilités des dossiers et le flux repository → provider → écran.
- [ ] Documenter trois versions minimum:
  - `1.2.0`: production hardening, CI multiplateforme, tests complets;
  - `1.1.0`: favoris, profil, thème et persistance;
  - `1.0.0`: catalogue, détail produit et panier.
- [ ] Capturer l’application en mode Web ou desktop sans afficher de données sensibles.
- [ ] Vérifier chaque lien et chaque commande depuis un clone propre.

**Résultat attendu:** un contributeur peut cloner le projet, le lancer, le tester et comprendre son architecture sans contexte oral.

---

## Task 9: Validation finale multiplateforme

**Files:**
- Aucun fichier nouveau; validation de tout le dépôt.

- [ ] Nettoyer puis récupérer les dépendances:

```powershell
flutter clean
flutter pub get
```

- [ ] Exécuter la qualité statique et tous les tests:

```powershell
flutter analyze
flutter test
flutter test integration_test/app_test.dart -d chrome
```

- [ ] Compiler les cibles disponibles localement:

```powershell
flutter build web
flutter build apk --debug
flutter build windows
```

- [ ] Compiler les cibles Apple sur runner macOS:

```bash
flutter build macos
flutter build ios --no-codesign
```

- [ ] Compiler Linux sur runner Linux:

```bash
flutter build linux
```

- [ ] Vérifier manuellement chaque parcours: chargement, recherche, filtre, tri, détail, favori, panier, profil, thème, langue, erreurs réseau et états vides.
- [ ] Vérifier les logs de performance en mode profile et l’absence d’overflow ou d’exception.
- [ ] Vérifier `git diff --check` et `git status --short`.
- [ ] Taguer la version finale uniquement après CI verte.

**Critères d’acceptation finaux:**

- [ ] 6 plateformes configurées et compilables dans les limites des runners disponibles.
- [ ] 10 tests unitaires minimum.
- [ ] 5 tests de widgets minimum.
- [ ] 2 tests d’intégration minimum.
- [ ] `flutter analyze` propre.
- [ ] CI verte.
- [ ] FR et EN fonctionnels.
- [ ] Labels sémantiques présents sur les interactions principales.
- [ ] Images lazy-loadées et mises en cache.
- [ ] README et changelog complets.
- [ ] APK et builds Web/Desktop publiés comme artefacts CI.

---

## Ordre recommandé d’exécution

1. Task 1: remettre la suite dans un état compilable.
2. Task 2: verrouiller la logique métier par les tests unitaires.
3. Task 3: ajouter FR/EN avant de multiplier les tests UI.
4. Task 4: optimiser le catalogue et les images.
5. Task 5: accessibilité et responsive.
6. Task 6: parcours d’intégration.
7. Task 7: CI/CD.
8. Task 8: README, captures et changelog.
9. Task 9: validation finale et artefacts.

Chaque tâche doit être validée par sa commande ciblée avant de passer à la suivante. Les builds iOS/macOS/Linux doivent être exécutés sur les runners appropriés lorsque ces toolchains ne sont pas disponibles sur Windows.
