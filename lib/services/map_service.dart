import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import '../models/tappable_polygon.dart';
import '../utils/map_helpers.dart';
import './data_service.dart'; 

class MapService {
  static AssetManifest? _cachedManifest;

  static Stream<List<TappablePolygon>> loadPolygonsStream(String inputPath, String currentLevel) async* {
    List<TappablePolygon> allPolygons = [];
    try {
      _cachedManifest ??= await AssetManifest.loadFromAssetBundle(rootBundle);
      var allAssets = _cachedManifest!.listAssets();
      
      List<String> files = inputPath.isEmpty 
          ? allAssets.where((path) => path.contains('regions') && path.endsWith('.json')).toList()
          : allAssets.where((path) => path.contains(inputPath) && path.endsWith('.json')).toList();

      for (var path in files) {
        await Future.delayed(const Duration(milliseconds: 5)); 
        final String response = await rootBundle.loadString(path);
        final data = json.decode(response);

        if (data['features'] != null) {
          for (var f in data['features']) {
            final props = f['properties'];
            final geom = f['geometry'];
            if (geom == null) continue;

            String pCode = '';
            if (currentLevel.toLowerCase().contains('province')) {
              pCode = props['adm2_psgc']?.toString() ?? props['id']?.toString() ?? '';
            }
            if (pCode.isEmpty) {
              pCode = props['ADM4_PCODE'] ?? props['ADM3_PCODE'] ?? 
                      props['ADM2_PCODE'] ?? props['ADM1_PCODE'] ?? '';
            }

            String name = props['NAME_4'] ?? props['NAME_3'] ?? 
                          props['NAME_2'] ?? props['NAME_1'] ?? 
                          props['ADM1_EN'] ?? props['REGION'] ?? 'Unknown Area';

            int count = DataService.getUserCountForArea(pCode, currentLevel);
            Color heatmapColor = MapHelpers.getHeatmapColor(count, currentLevel);

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

            if (multiPoints.isNotEmpty) {
              allPolygons.add(TappablePolygon(
                id: pCode, 
                areaName: name,
                userCount: count,
                points: multiPoints[0],
                multiPoints: multiPoints,
                color: heatmapColor,
              ));
            }
          }
          yield List.from(allPolygons);
        }
      }
    } catch (e) {
      debugPrint("Error loading map: $e");
    }
  }
}