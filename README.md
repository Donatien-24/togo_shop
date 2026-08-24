# togoshop
# TogoShop
A new Flutter project.
Application e-commerce Flutter pour les **produits artisanaux et locaux du Togo**.
## Getting Started
Le projet illustre une architecture en couches et une maîtrise de **Riverpod** : `FutureProvider`, `StateNotifierProvider`, `StateProvider`, `AsyncValue` (loading / error / data), et persistance locale avec **SharedPreferences**.
This project is a starting point for a Flutter application.
## Captures d’écran
A few resources to get you started if this is your first Flutter project:
Lancez l’app puis ajoutez vos captures dans `docs/` si vous publiez le dépôt.
- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
## Fonctionnalités
For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
- Catalogue (image, nom, prix, catégorie, note)
- Recherche par nom
- Filtrage par catégorie (Artisanat, Mode, Beauté, Décoration, Alimentaire)
- Tri par prix croissant / décroissant / note
- Détail produit (Hero, stock, panier, favoris)
- Panier (ajout, suppression, quantités, sous-total, total, vider)
- Favoris persistés localement
- Profil utilisateur simulé + historique de commandes
- Thème Material 3 (clair / sombre / système) persisté
- Interface responsive (mobile et tablette)
## Stack
| Outil | Usage |
| --- | --- |
| Flutter 3 | UI Material 3 |
| flutter_riverpod | État de l’application |
| shared_preferences | Favoris et préférences |
Aucune autre dépendance métier n’est requise.
## Architecture
```text
lib/
├── main.dart
├── core/           constants, thème, utilitaires
├── models/         Product, CartItem, UserProfile, ProductFilter
├── repositories/   ProductRepository (JSON local)
├── providers/      Riverpod
├── screens/        Catalogue, détail, panier, favoris, profil
├── widgets/        Cards, loading, erreurs, tuiles panier
└── data/           copie de products.json
assets/data/products.json   source chargée au runtime
```
## Providers Riverpod
| Provider | Type | Rôle |
| --- | --- | --- |
| `productRepositoryProvider` | `Provider` | Accès au dépôt produits |
| `productsProvider` | `FutureProvider<List<Product>>` | Chargement asynchrone |
| `cartProvider` | `StateNotifierProvider` | Panier |
| `favoritesProvider` | `StateNotifierProvider` | Favoris + SharedPreferences |
| `filterProvider` | `StateProvider` | Recherche, catégorie, tri |
| `profileProvider` | `StateNotifierProvider` | Profil mock + nom persisté |
| `themeModeProvider` | `StateNotifierProvider` | Thème persisté |
| `selectedProductIdProvider` | `StateProvider` | Produit transmis à l’écran détail |
| `filteredProductsProvider` | `Provider<AsyncValue<…>>` | Catalogue dérivé |
Le détail produit **ne reçoit pas** le modèle uniquement via le constructeur : l’id est posé dans `selectedProductIdProvider`, puis `selectedProductProvider` expose un `AsyncValue<Product?>`.
## Lancer le projet
Prérequis : [Flutter SDK](https://docs.flutter.dev/get-started/install) (SDK Dart ^3.12).
```bash
git clone <url-du-depot>
cd TogoShop
flutter pub get
flutter run
```
Cibles générées : Android, iOS, Web, Windows.
Les images du catalogue sont chargées depuis Unsplash : une connexion Internet est nécessaire.
## Tests
```bash
flutter test
flutter analyze
```
## Licence
Projet de démonstration pédagogique. Libre d’usage pour un dépôt GitHub public.