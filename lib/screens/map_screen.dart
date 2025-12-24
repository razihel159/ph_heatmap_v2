import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../services/map_service.dart';
import '../models/tappable_polygon.dart';
import '../widget/heatmap_viewer.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<TappablePolygon> polygons = [];
  bool isLoading = false;
  String currentLevel = 'region';
  StreamSubscription? _loaderSubscription;

  @override
  void initState() {
    super.initState();
    // Pag-load ng initial regions file
    _startLoading('regions.0.001.json', 'region');
  }

  void _startLoading(String path, String level) {
    _loaderSubscription?.cancel();
    
    setState(() {
      polygons = []; 
      isLoading = true;
      currentLevel = level;
    });

    _loaderSubscription = MapService.loadPolygonsStream(path).listen(
      (updatedPolygons) {
        setState(() {
          polygons = updatedPolygons;
        });
      },
      onDone: () => setState(() => isLoading = false),
    );
  }

  @override
  void dispose() {
    _loaderSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HeatmapViewer(
            polygons: polygons,
            mapController: _mapController,
            borderWidth: 1.0, // Pinanatiling 1.0 para laging may border
            onPolygonTap: (area) => print("Selected: ${area.areaName}"),
          ),
          LayerControlPanel(
            currentLevel: currentLevel,
            onSelect: (path, level) => _startLoading(path, level),
          ),
          if (isLoading)
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.black54,
                    child: Text(
                      "Loading ${polygons.length} areas...",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}