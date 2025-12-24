import 'package:flutter/material.dart';
import '../logic/drill_down_controller.dart';

class LayerControlPanel extends StatelessWidget {
  final Function(String path, String level) onSelect;
  final String currentLevel;

  const LayerControlPanel({super.key, required this.onSelect, required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem("Regions", "region", Icons.map),
          _buildItem("Provinces", "province", Icons.location_city),
          _buildItem("Municipalities", "municipality", Icons.business),
          _buildItem("Barangays", "barangay", Icons.home),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String level, IconData icon) {
    bool isActive = currentLevel == level;
    return ListTile(
      dense: true,
      leading: Icon(icon, color: isActive ? Colors.blue : Colors.grey, size: 20),
      title: Text(title, style: TextStyle(
        fontSize: 13,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        color: isActive ? Colors.blue : Colors.black87,
      )),
      onTap: () {
        String path = DrillDownController.getFolderByLevel(level);
        onSelect(path, level);
      },
    );
  }
}