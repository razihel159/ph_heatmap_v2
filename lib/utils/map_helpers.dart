import 'package:flutter/material.dart';

class MapHelpers {
  static Color getHeatmapColor(int count, String level) {
    int red, orange, yellow, green;

    if (level == 'region') {
      red = 10000; orange = 7000; yellow = 3000; green = 1000;
    } else if (level == 'province') {
      red = 5000; orange = 3500; yellow = 1500; green = 500;
    } else if (level == 'municipality') {
      red = 1000; orange = 700; yellow = 300; green = 100;
    } else { // barangay
      red = 50; orange = 30; yellow = 15; green = 5;
    }

    if (count >= red) return Colors.red;
    if (count >= orange) return Colors.orange;
    if (count >= yellow) return Colors.yellow;
    if (count >= green) return Colors.green;
    return Colors.blue; 
  }

  static String formatAreaName(String name) {
    if (name == 'Unknown' || name.isEmpty) return "AREA NAME N/A";
    return name.toUpperCase();
  }

  static Color getTextColor(int count) {
    return Colors.black87;
  }
}