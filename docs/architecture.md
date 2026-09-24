# Architecture TogoShop

## Couches

- `models/`: objets immuables et sérialisation des produits et commandes.
- `repositories/`: accès aux données locales et frontière remplaçable pour les tests.
- `providers/`: état Riverpod, calculs dérivés, persistance SharedPreferences.
- `screens/`: parcours principaux et composition responsive.
- `widgets/`: composants réutilisables, images cacheables et états de chargement.
- `core/`: thème, constantes, formatage et préférence de locale.

## Flux produit

`assets/data/products.json` est chargé par `ProductRepository`, exposé via `productsProvider`, puis filtré et trié par `filteredProductsProvider`. `HomeScreen` affiche le résultat dans `CatalogGrid`, qui construit les cartes avec `GridView.builder`.

## État local

Le panier reste en mémoire. Les favoris, le nom, le thème et la langue sont persistés avec `SharedPreferences`. Les tests remplacent cette dépendance par les valeurs mockées de Flutter.

## Portabilité

L’application n’utilise pas d’API native spécifique dans son domaine métier. Les builds Apple sont produits sur macOS, tandis que les builds Windows et Linux utilisent leurs runners natifs dans GitHub Actions.