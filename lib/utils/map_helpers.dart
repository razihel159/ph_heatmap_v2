import 'package:flutter/material.dart';

class MapHelpers {
  /// Color logic para sa Heatmap Polygons
  static Color getHeatmapColor(int count) {
    if (count >= 150) {
      return Colors.red.withOpacity(0.7); // High density
    } else if (count >= 100) {
      return Colors.orange.withOpacity(0.6);
    } else if (count >= 50) {
      return Colors.yellow.withOpacity(0.5);
    } else if (count > 0) {
      return Colors.green.withOpacity(0.4); // Low density
    } else {
      return Colors.blue.withOpacity(0.2); // Default / No data
    }
  }

  /// Color logic para sa Text sa Ranking Sidebar
  static Color getTextColor(int count) {
    if (count >= 150) return Colors.red.shade900;
    if (count >= 50) return Colors.orange.shade900;
    return Colors.green.shade900;
  }

  /// Helper para sa pag-format ng pangalan
  static String formatAreaName(String name) {
    return name.toUpperCase();
  }
}