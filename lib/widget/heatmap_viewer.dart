import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/tappable_polygon.dart';

class HeatmapViewer extends StatelessWidget {
  final List<TappablePolygon> polygons;
  final MapController mapController;
  final Function(TappablePolygon) onPolygonTap;
  final double borderWidth;

  const HeatmapViewer({
    super.key,
    required this.polygons,
    required this.mapController,
    required this.onPolygonTap,
    this.borderWidth = 1.0, // Default na may kapal ang border
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: const MapOptions(
        initialCenter: LatLng(12.8797, 121.7740),
        initialZoom: 6.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        PolygonLayer(
          polygons: polygons.expand((poly) {
            return poly.multiPoints.map((points) => Polygon(
              points: points,
              color: poly.color,
              isFilled: true,
              borderStrokeWidth: borderWidth, // Importante: Ipinapakita ang border ng bawat polygon
              borderColor: Colors.black.withOpacity(0.5), // Malinaw na boundary line
            ));
          }).toList(),
        ),
      ],
    );
  }
}