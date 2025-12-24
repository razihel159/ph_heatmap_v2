import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../services/map_service.dart';
import '../models/tappable_polygon.dart';
import '../widget/heatmap_viewer.dart';
import '../widget/layer_control_panel.dart';
import '../widget/ranking_sidebar.dart';
import '../logic/drill_down_controller.dart';
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
    Future.delayed(const Duration(milliseconds: 500), () {
      _startLoading(DrillDownController.getFolderByLevel('region'), 'region');
    });
  }

  void _handlePolygonTap(TappablePolygon area) {
    final next = DrillDownController.getNextLevel(currentLevel);
    if (next != null) {
      _mapController.move(area.points[0], DrillDownController.getZoomLevel(currentLevel));
      _startLoading(next['path']!, next['name']!);
    }
  }

  void _startLoading(String path, String level) {
    _loaderSubscription?.cancel();
    setState(() {
      polygons = []; 
      isLoading = true;
      currentLevel = level;
    });
    _loaderSubscription = MapService.loadPolygonsStream(path, level).listen(
      (updatedPolygons) {
        if (mounted) setState(() => polygons = updatedPolygons);
      },
      onDone: () => setState(() => isLoading = false),
      onError: (e) => setState(() => isLoading = false),
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
            borderWidth: 1.0,
            onPolygonTap: (area) => _handlePolygonTap(area),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: LayerControlPanel(
              currentLevel: currentLevel,
              onSelect: (path, level) => _startLoading(path, level),
            ),
          ),
          RankingSidebar(
            polygons: polygons,
            isLoading: isLoading,
            onAreaTap: (area) {
              _mapController.move(area.points[0], _mapController.camera.zoom);
            },
          ),
          if (isLoading)
            const Positioned(bottom: 20, left: 20, child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}