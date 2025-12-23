import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/map_service.dart';
import '../models/tappable_polygon.dart';
import '../widget/heatmap_viewer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<TappablePolygon> polygons = [];
  bool isLoading = false;
  String currentLevel = 'country';

  @override
  void initState() {
    super.initState();
    _loadData('country_lowres/', 'country');
  }

  Future<void> _loadData(String folder, String level) async {
    setState(() => isLoading = true);
    
    // Automatic loading base sa folder na binigay ng button/controller
    final data = await MapService.loadPolygonsForLayer(folder);
    
    setState(() {
      polygons = data;
      currentLevel = level;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HeatmapViewer(
            polygons: polygons,
            mapController: _mapController,
            onPolygonTap: (area) => print("Selected: ${area.areaName}"),
          ),
          
          // Dito lalabas ang Dashboard Buttons mo
          LayerControlPanel(
            currentLevel: currentLevel,
            onSelect: (folder, level) => _loadData(folder, level),
          ),

          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}