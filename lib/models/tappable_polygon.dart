import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

// INAYOS NA IMPORT: Mula sa 'models' folder, aakyat sa 'lib', tapos papasok sa 'logic'
import '../logic/drill_down_controller.dart'; 

class TappablePolygon {
  final String id;
  final String areaName;
  final int userCount;
  final List<LatLng> points;
  final List<List<LatLng>> multiPoints;
  final Color color;

  TappablePolygon({
    required this.id,
    required this.areaName,
    required this.userCount,
    required this.points,
    required this.multiPoints,
    required this.color,
  });
}

class LayerControlPanel extends StatelessWidget {
  final Function(String folder, String level) onSelect;
  final String currentLevel;

  const LayerControlPanel({
    super.key, 
    required this.onSelect, 
    required this.currentLevel
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 15,
      top: 100,
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                "MAP LAYERS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            _buildLayerItem("Regions", "region", Icons.map, Colors.blue),
            _buildLayerItem("Provinces", "province", Icons.location_city, Colors.green),
            _buildLayerItem("Municipalities", "municity", Icons.business, Colors.orange),
            _buildLayerItem("Barangays", "barangay", Icons.home, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerItem(String title, String level, IconData icon, Color color) {
    bool isActive = currentLevel == level;
    return GestureDetector(
      onTap: () {
        // Tinatawag ang DrillDownController gamit ang tamang import
        String folderPath = DrillDownController.getFolderByLevel(level);
        onSelect(folderPath, level);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              color: isActive ? color : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 15),
            Text(
              title, 
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? color : Colors.black87,
                fontSize: 14,
              )
            ),
            const Spacer(),
            if (isActive)
              Icon(Icons.check_circle, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}