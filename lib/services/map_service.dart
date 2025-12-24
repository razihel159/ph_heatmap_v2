import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import '../models/tappable_polygon.dart';

class MapService {
  static Stream<List<TappablePolygon>> loadPolygonsStream(String inputPath) async* {
    List<TappablePolygon> allPolygons = [];
    
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final List<String> files = manifest.listAssets().where((path) => 
        path.contains(inputPath) && path.endsWith('.json')).toList();

      for (String path in files) {
        try {
          final String response = await rootBundle.loadString(path);
          final dynamic decodedData = json.decode(response);
          
          if (decodedData == null || decodedData['features'] == null) continue;

          final features = decodedData['features'] as List;

          for (var f in features) {
            final props = f['properties'] as Map<String, dynamic>? ?? {};
            final geometry = f['geometry'] as Map<String, dynamic>?;

            if (geometry == null) continue;

            String name = props['NAME_1'] ?? props['NAME_2'] ?? props['NAME_3'] ?? 'Unknown';
            String id = props['ADM1_PCODE'] ?? props['ADM2_PCODE'] ?? props['ADM3_PCODE'] ?? path;

            List<List<LatLng>> multiPoints = [];
            
            if (geometry['type'] == 'Polygon') {
              var coords = geometry['coordinates'][0];
              multiPoints.add(coords.map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList());
            } else if (geometry['type'] == 'MultiPolygon') {
              for (var poly in geometry['coordinates']) {
                multiPoints.add(poly[0].map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList());
              }
            }

            allPolygons.add(TappablePolygon(
              id: id,
              areaName: name,
              userCount: 0,
              points: multiPoints.isNotEmpty ? multiPoints[0] : [],
              multiPoints: multiPoints,
              color: Colors.blue.withOpacity(0.4),
            ));
          }
          yield List.from(allPolygons); 
        } catch (e) {
          debugPrint("Skipped $path: $e");
        }
      }
    } catch (e) {
      debugPrint("Global Error: $e");
    }
  }
}