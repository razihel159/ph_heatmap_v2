import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
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
  final Function(String path, String level) onSelect;
  final String currentLevel;

  const LayerControlPanel({super.key, required this.onSelect, required this.currentLevel});

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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildItem("Regions", "region", Icons.map),
            _buildItem("Provinces", "province", Icons.location_city),
            _buildItem("Municipalities", "municity", Icons.business),
            _buildItem("Barangays", "barangay", Icons.home),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, String level, IconData icon) {
    bool isActive = currentLevel == level;
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.blue : Colors.grey),
      title: Text(title, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      onTap: () {
        // PAGGAMIT NG CONTROLLER PARA SA PATH
        String path = DrillDownController.getFolderByLevel(level);
        onSelect(path, level);
      },
    );
  }
}