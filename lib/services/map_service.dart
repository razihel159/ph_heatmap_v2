// lib/services/map_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import '../models/tappable_polygon.dart';

class MapService {
  static AssetManifest? _cachedManifest;

  static Stream<List<TappablePolygon>> loadPolygonsStream(String inputPath) async* {
    List<TappablePolygon> allPolygons = [];
    
    try {
      _cachedManifest ??= await AssetManifest.loadFromAssetBundle(rootBundle);
      
      var files = _cachedManifest!.listAssets()
          .where((path) => path.contains(inputPath) && path.endsWith('.json'))
          .toList();

      for (var path in files) {
        // ETO ANG PINAKA-IMPORTANTE:
        // Pinapatakbo nito ang UI thread para hindi mag-white screen ang Chrome.
        await Future.delayed(Duration.zero); 

        final String response = await rootBundle.loadString(path);
        final data = json.decode(response);
        
        if (data['features'] != null) {
          for (var f in data['features']) {
            final props = f['properties'];
            final geom = f['geometry'];
            if (geom == null) continue;

            // Simple property mapping
            String pCode = props['ADM3_PCODE'] ?? props['ADM2_PCODE'] ?? props['ADM1_PCODE'] ?? '';
            String name = props['NAME_3'] ?? props['NAME_2'] ?? props['NAME_1'] ?? 'Unknown';

            List<List<LatLng>> multiPoints = [];
            if (geom['type'] == 'Polygon') {
              var coords = geom['coordinates'][0];
              multiPoints.add(coords.map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList());
            } else if (geom['type'] == 'MultiPolygon') {
              for (var poly in geom['coordinates']) {
                if (poly.isNotEmpty) {
                  multiPoints.add(poly[0].map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList());
                }
              }
            }

            allPolygons.add(TappablePolygon(
              id: pCode, 
              areaName: name,
              userCount: 0,
              points: multiPoints.isNotEmpty ? multiPoints[0] : [],
              multiPoints: multiPoints,
              color: Colors.blue.withOpacity(0.3),
            ));
          }
          yield List.from(allPolygons);
        }
      }
    } catch (e) {
      debugPrint("Error loading: $e");
    }
  }
}