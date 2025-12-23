import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import '../models/tappable_polygon.dart';
import '../utils/map_helpers.dart';
import 'data_service.dart';

class MapService {
  static Future<List<TappablePolygon>> loadPolygonsForLayer(String folder) async {
    List<TappablePolygon> allPolygons = [];
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final List<String> allAssets = manifest.listAssets();
      String targetFolder = 'assets/${folder.replaceAll('assets/', '')}';
      
      // I-load ang lahat ng JSON sa folder (limitado sa 10 files para sa performance)
      List<String> files = allAssets.where((path) => path.startsWith(targetFolder) && path.endsWith('.json')).take(10).toList();

      for (String path in files) {
        final String response = await rootBundle.loadString(path);
        final data = json.decode(response);
        final features = data['features'] as List;

        for (var f in features) {
          final props = f['properties'] as Map<String, dynamic>;
          final geometry = f['geometry'] as Map<String, dynamic>;
          String pCode = props['ADM3_PCODE'] ?? props['ADM2_PCODE'] ?? props['ADM1_PCODE'] ?? '';
          String name = props['NAME_3'] ?? props['NAME_2'] ?? props['NAME_1'] ?? 'Unknown';

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
            id: pCode,
            areaName: name,
            userCount: DataService.getUserCountForArea(pCode),
            points: multiPoints.isNotEmpty ? multiPoints[0] : [],
            multiPoints: multiPoints,
            color: MapHelpers.getHeatmapColor(DataService.getUserCountForArea(pCode)),
          ));
        }
      }
    } catch (e) { print("Error: $e"); }
    return allPolygons;
  }
}