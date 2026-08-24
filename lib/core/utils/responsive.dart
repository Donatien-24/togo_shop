import 'package:flutter/material.dart';
/// Grille adaptative : 2 colonnes (mobile), 3 (tablette), 4 (large).
int catalogCrossAxisCount(double width) {
  if (width >= 1100) return 4;
  if (width >= 700) return 3;
  return 2;
}
bool isTabletLayout(BuildContext context) {
  return MediaQuery.sizeOf(context).shortestSide >= 600;
}
double catalogChildAspectRatio(double width) {
  if (width >= 700) return 0.72;
  return 0.68;
}