import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../widgets/catalog_toolbar.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: const Column(
        children: [
          CatalogToolbar(),
          Expanded(
            child: CatalogGrid(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 12),
            ),
          ),
        ],
      ),
    );
  }
}