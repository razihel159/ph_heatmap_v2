import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/tappable_polygon.dart';

class HeatmapViewer extends StatelessWidget {
  final List<TappablePolygon> polygons;
  final MapController mapController;
  final Function(TappablePolygon) onPolygonTap;

  const HeatmapViewer({
    super.key,
    required this.polygons,
    required this.mapController,
    required this.onPolygonTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: const LatLng(12.8797, 121.7740),
        initialZoom: 5.5,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all, // Pinagana na uli ang zoom/scroll
        ),
        onTap: (tapPosition, point) {
          _handleMapTap(point);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.polygon_project',
        ),
        PolygonLayer(
          polygons: polygons.expand<Polygon>((tp) => tp.multiPoints.map((island) => Polygon(
            points: island,
            color: tp.color.withOpacity(0.7),
            isFilled: true,
            borderStrokeWidth: 1,
            borderColor: Colors.white,
          ))).toList(),
        ),
      ],
    );
  }

  void _handleMapTap(LatLng tapPoint) {
    // Naka-reverse loop tayo para ang "pinaka-ibabaw" na polygon ang maunang ma-detect
    for (var tappablePolygon in polygons.reversed) {
      bool hit = false;
      
      // Importante: I-check ang bawat island (MultiPolygon)
      for (var island in tappablePolygon.multiPoints) {
        if (_isPointInPolygon(tapPoint, island)) {
          hit = true;
          break;
        }
      }

      if (hit) {
        onPolygonTap(tappablePolygon);
        return; // Stop agad pag may nahanap na match
      }
    }
  }

  // Improved Ray Casting Algorithm para sa mas accurate na click detection
  bool _isPointInPolygon(LatLng point, List<LatLng> vertices) {
    if (vertices.isEmpty) return false;
    
    int intersectCount = 0;
    for (int j = 0; j < vertices.length; j++) {
      int next = (j + 1) % vertices.length;
      
      if (((vertices[j].latitude <= point.latitude && point.latitude < vertices[next].latitude) ||
          (vertices[next].latitude <= point.latitude && point.latitude < vertices[j].latitude)) &&
          (point.longitude < (vertices[next].longitude - vertices[j].longitude) * (point.latitude - vertices[j].latitude) / (vertices[next].latitude - vertices[j].latitude) + vertices[j].longitude)) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1;
  }
}